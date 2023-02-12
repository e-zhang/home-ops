local ca = std.base64(importstr 'data://get-ca/out/Lab_Root.crt');

{
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: 'lab-ca',
    namespace: 'homeassistant',
  },
  type: 'Opaque',
  data: {
    'ca.crt': ca,
  },
}
