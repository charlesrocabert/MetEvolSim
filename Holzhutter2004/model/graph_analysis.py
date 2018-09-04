import networkx as nx
import matplotlib.pyplot as plt


def load_graph():
	nodes = []
	edges = []
	f = open("adjacency_list.txt", "r")
	l = f.readline()
	while l:
		l = l.strip("\n").split(" ")
		if l[0] not in nodes:
			nodes.append(l[0])
		if l[1] not in nodes:
			nodes.append(l[1])
		edges.append(l)
		l = f.readline()
	f.close()
	G = nx.Graph()
	for node in nodes:
		G.add_node(node)
	for edge in edges:
		G.add_edge(edge[0], edge[1])
	return G

def load_met_order():
	met = []
	f = open("order_example.txt", "r")
	l = f.readline()
	l = f.readline()
	while l:
		l = l.strip("\n").split(" ")
		met.append(l[0])
		l = f.readline()
	f.close()
	return met


##################
#      MAIN      #
##################

G        = load_graph()
clust    = nx.clustering(G)
met_list = load_met_order()

f = open("clustering.txt", "w")
f.write("name clust\n")
for met in met_list:
	f.write(met+" "+str(clust[met])+"\n")
f.close()


