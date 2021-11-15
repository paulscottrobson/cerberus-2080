# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		makeruntime.py
#		Purpose :	Create autogenerated runtime class
#		Date :		15th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import re

h = open("runtime.py","w")
h.write("#\n#\tThis file is automatically generated.\n#\n")
h.write("class HPLCRuntime(object):\n")

h.write("\tdef getCode(self):\n")
rom = [x for x in open("runtime.rom","rb").read(-1)]
h.write("\t\treturn [{0}]\n\n".format(",".join([str(x) for x in rom])))

h.write("\tdef getRoutines(self):\n")
h.write("\t\treturn {\n")

for l in open("runtime.lst").readlines():
	if l.find("RTF_") >= 0:
		m = re.match("^RTF_(.*?)\\s*\\=\\s*\\$([0-9A-Fa-f]+)",l)
		if m is not None:
			h.write("\t\t\t\"{0}\":0x{1},\n".format(m.group(1).lower().replace("_","."),m.group(2).lower()))
h.write("\t\t\t\"base.address\":0x{0:04x}\n".format(rom[1]+rom[2]*256))
h.write("\t\t}\n")

