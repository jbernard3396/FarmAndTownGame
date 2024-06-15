extends Node


func loadJsonFile(filePath):
	if !FileAccess.file_exists(filePath):
		print("file doesn't exist")
		return
	var dataFile = FileAccess.open(filePath, FileAccess.READ)
	var parsedFile = JSON.parse_string(dataFile.get_as_text())
	if !parsedFile is Dictionary:
		print("error reading file")
	return parsedFile
