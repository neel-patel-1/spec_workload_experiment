"""Single Server for Spec Eval."""

import geni.portal as portal
import geni.rspec.pg as rspec

# Create a Request object to start building the RSpec.
request = portal.context.makeRequestRSpec()

node = request.RawPC('node' )
node.hardware_type = 'c6220'
node.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD'

# Write the request in RSpec format
portal.context.printRequestRSpec()