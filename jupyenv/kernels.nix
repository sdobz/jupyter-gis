{pythonEnv}:
{pkgs, ...}: {
  kernel.python.minimal = {
    enable = true;
    env = pythonEnv;
  };
}
