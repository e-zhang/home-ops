local certs = import './certificates.libsonnet';
local contourYAML = importstr './include/contour.yaml';

local contour = std.parseYaml(contourYAML);

contour + certs
