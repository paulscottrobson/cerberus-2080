# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		error.py
#		Purpose :	Error class
#		Date :		13th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

# *******************************************************************************************
#
#										HPL Exception
#
# *******************************************************************************************

class HPLException(Exception):
	def __str__(self):
		msg = Exception.__str__(self)
		return msg if HPLException.LINE <= 0 else "{0} ({1}:{2})".format(msg,HPLException.FILE,HPLException.LINE)

HPLException.FILE = None
HPLException.LINE = 0

if __name__ == '__main__':	
	x = HPLException("Error !!")
	print(">>",str(x))
	raise x

	