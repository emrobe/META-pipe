import argparse

class ContigFile:
    def __init__(self, path):
       self.f = open(path)
       self.contigs = dict()

    def read(self):
        while True:
          line = self.f.readline()
          if line.startswith(">"):
              self.contigs[line[1:].strip()] = self.f.tell()
          elif line == '':
              return


    def get_contig(self, contig):
        output = []
        self.f.seek(self.contigs[contig])
        while True:
            line = self.f.readline()
            if line.startswith(">") or line == '':
                return "".join(output)
            else:
                output.append(line)


class Main:
    def __init__(self):
        parser = argparse.ArgumentParser(description="META-pipe MGA Exporter (MGA to fasta)")
        parser.add_argument("-i", "--input", dest="input", help="Contig file")
        parser.add_argument("-o", "--output", dest="output", help="MGA output")
        self.args = parser.parse_args()
        self.contigs = ContigFile(self.args.input)
        self.contigs.read()

    def run(self):
        firstLine = True
        contig = ""
        contigId = ""
        for line in open(self.args.output):
            if(line.startswith("# contig")):
                if(contigId != line[1:].strip()):
                  contigId = line[1:].strip()
                  contig = self.contigs.get_contig(contigId)
            elif(line.startswith("gene")):
                splitLine = line.split("\t")
#                print(splitLine)
                print(">" + contigId + "_" + splitLine[0])
                print(contig[int(splitLine[1]):int(splitLine[2])])


if __name__ == "__main__":
    main = Main()
    main.run()
