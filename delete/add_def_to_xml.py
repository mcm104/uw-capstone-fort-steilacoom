import csv
import xml.etree.ElementTree as ET

definition_dict = {}

with open('term_polishing_spreadsheet_2022_04_16.csv', mode='r') as spreadsheet:
	csv_reader = csv.reader(spreadsheet, delimiter=',')
	line_count = 0

	for line in csv_reader:
		if line_count != 0:
			tier_1 = line[0]
			tier_2 = line[1]
			tier_3 = line[2]
			tier_4 = line[3]
			tier_5 = line[4]
			tier_6 = line[5]
			definition = line[8]

			if definition != "":
				if tier_6 != "":
					definition_dict[tier_6] = definition
				elif tier_5 != "":
					definition_dict[tier_5] = definition
				elif tier_4 != "":
					definition_dict[tier_4] = definition
				elif tier_3 != "":
					definition_dict[tier_3] = definition
				elif tier_2 != "":
					definition_dict[tier_2] = definition
				else:
					definition_dict[tier_1] = definition

		line_count += 1

###

tree = ET.parse('naf_xmlWORKING.xml')

nameAuthorityFile = tree.getroot()

for agents in nameAuthorityFile:
	for agent in agents:
		# create list of child elements
		children = []
		for child in agent:
			children.append(child.tag)
		# add or update definition
		for child in agent:
			if child.tag == "preferredName":
				preferredName = child.text
				if preferredName in definition_dict.keys():
					if "biographicalInfo" not in children:
						add_definition = ET.SubElement(agent, "biographicalInfo")
					add_definition.text = definition_dict[preferredName]

#tree.write('naf_xmlWORKING.xml')

###

update_index = False

tree = ET.parse('index_xmlWORKING.xml')

newsletterIndex = tree.getroot()

for terms in newsletterIndex:
	for term in terms:
		# create list of child elements
		children = []
		for child in term:
			children.append(child.tag)
		# add or update definition
		for child in term:
			if child.tag == "preferredTerm":
				preferredTerm = child.text
				if preferredTerm in definition_dict.keys():
					if "definition" not in children:
						add_definition = ET.SubElement(term, "definition")
					add_definition.text = definition_dict[preferredTerm]

if update_index == True:
	tree.write('index_xmlWORKING.xml')
