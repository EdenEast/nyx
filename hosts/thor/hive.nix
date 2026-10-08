{hostname, ...}: {
  deployment = {
    allowLocalDeployment = true;
    targetHost = hostname;
    targetUser = "eden";
  };
}
