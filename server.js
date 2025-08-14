// server.js
const express = require('express');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5173;
const ENABLE_SHELL = process.env.ENABLE_SHELL === '1';

app.use(express.json());
app.use('/', express.static(path.join(__dirname, 'webui')));

const TOOL_SCRIPTS = {
  docker: path.join(__dirname, 'scripts', 'build_docker.sh'),
  buildkit: path.join(__dirname, 'scripts', 'build_buildkit.sh'),
  podman: path.join(__dirname, 'scripts', 'build_podman.sh'),
  kaniko: path.join(__dirname, 'scripts', 'build_kaniko_local.sh')
};

function runCmd(cmd, args = [], env = {}) {
  return new Promise((resolve) => {
    const proc = spawn(cmd, args, { env: { ...process.env, ...env }, shell: true });
    let out = '';
    proc.stdout.on('data', (d) => (out += d.toString()));
    proc.stderr.on('data', (d) => (out += d.toString()));
    proc.on('close', (code) => resolve({ code, out }));
  });
}

app.get('/api/info', async (_req, res) => {
  const versions = {};
  const tryCmd = async (name, cmd, args = []) => {
    const result = await runCmd(cmd, args);
    versions[name] = result.code === 0 ? result.out.trim() : 'not found';
  };
  await Promise.all([
    tryCmd('docker', 'docker', ['version --format "{{.Server.Version}}"']),
    tryCmd('buildx', 'docker', ['buildx version']),
    tryCmd('podman', 'podman', ['--version']),
    tryCmd('kaniko', 'echo', ['gcr.io/kaniko-project/executor:latest'])
  ]);
  res.json({ ENABLE_SHELL, versions });
});

app.post('/api/build', async (req, res) => {
  const { tool } = req.body || {};
  if (!['docker', 'buildkit', 'podman', 'kaniko'].includes(tool)) {
    return res.status(400).json({ error: 'Invalid tool' });
  }
  if (!ENABLE_SHELL) {
    return res.json({ note: 'Shell execution disabled', tool, command: TOOL_SCRIPTS[tool] });
  }
  const script = TOOL_SCRIPTS[tool];
  const { code, out } = await runCmd(script);
  res.json({ tool, code, out });
});

app.post('/api/run', async (req, res) => {
  const { image } = req.body || {};
  const img = image || 'buildshow/app:docker';
  if (!ENABLE_SHELL) return res.json({ note: 'Shell execution disabled', image: img });
  const script = path.join(__dirname, 'scripts', 'run_image.sh');
  const { code, out } = await runCmd(script, [img]);
  res.json({ image: img, code, out });
});

app.post('/api/clean', async (_req, res) => {
  if (!ENABLE_SHELL) return res.json({ note: 'Shell execution disabled' });
  const script = path.join(__dirname, 'scripts', 'clean.sh');
  const { code, out } = await runCmd(script);
  res.json({ code, out });
});

app.listen(PORT, () => {
  console.log(`GUI available at http://localhost:${PORT}`);
  console.log(`ENABLE_SHELL=${ENABLE_SHELL ? '1' : '0'}`);
});
