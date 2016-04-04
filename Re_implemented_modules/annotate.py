import sqlite3
import argparse
from collections import defaultdict, deque

SPACE=21

class Results:
  def __init__(self):
    pass


class InterProResults(Results):
  def __init__(self, filename):
    self.f = open(filename)

  def get_item(self):
    done = False
    hit = dict()

    l = self.f.readline()
    while(l.startswith("#")):
      l = self.f.readline()

    if(not l):
      return None

    lsplit = l.split("\t")

    hit["query_name"] = lsplit[0]
    #hit["crc64"] = lsplit[1]
    hit["len"] = lsplit[2]
    hit["method"] = lsplit[3]
    hit["db_entry"] = lsplit[4]
    hit["db_member"] = lsplit[5]
    hit["start"] = lsplit[6]
    hit["end"] = lsplit[7]
    hit["evalue"] = lsplit[8]
    hit["status"] = lsplit[9]
    hit["date"] = lsplit[10]
    if(len(lsplit) > 11):
      hit["ipro"] = lsplit[11]
      hit["desc"] = lsplit[12]
      hit["go"] = lsplit[13]
    return hit

class BlastResults(Results):
  def __init__(self, filename):
    self.f = open(filename)
    self.used_names = set()

  def get_item(self):
    done = False

    hit = dict()

    l = self.f.readline()
    while(l and l.split("\t")[0] in self.used_names):
      l = self.f.readline()
    if(not l):
      return None

    lsplit = l.split("\t")

    hit["gene_name"] = lsplit[0]
    self.used_names.add(lsplit[0])
    hit["db_name"] = lsplit[1]
    hit["percent_id"] = lsplit[2]
    hit["hit_length"] = lsplit[3]
    hit["mismatches"] = lsplit[4]
    hit["gap_openings"] = lsplit[5]
    hit["start"] = lsplit[6]
    hit["end"] = lsplit[7]
    hit["s_start"] = lsplit[8]
    hit["s_end"] = lsplit[9]
    hit["evalue"] = lsplit[10]
    hit["score"] = lsplit[11]

    return hit

class BlastDB:
  def __init__(self):
    self.cons = list()

  def add_db(self, filename):
    self.cons.append(sqlite3.connect(filename))

  def get_annotation(self, seq_id):
    for element in self.cons:
      c = element.cursor()
      c.execute('SELECT * from db WHERE ID=?', (seq_id,))
      element.commit()
      res = c.fetchone()
      if(res != None):
        print "DB QUERY" + str(res)

class MgaResults(Results):
  def __init__(self, filename, contigs):
    self.f = open(filename)
    self.contigs = contigs

  def get_item(self):
    source = self.f.readline()[2:].strip().split(" ")[0]
    if(not source):
      return False
    extra = self.f.readline()[2:].strip()
    extra2 = self.f.readline()[2:].strip()
    genes = list()
    while True:
      position = self.f.tell()
      tempLine = self.f.readline().strip()
      if(not tempLine):
        break
      if(tempLine.startswith("#")):
        self.f.seek(position)
        break
      else:
        genes.append(tempLine)
    for element in genes:
      pred = Prediction(source, element)
      self.contigs[source].predicted[pred.name] = pred
    return True
   

class InputResults(Results):
  def __init__(self, filename):
    self.f = open(filename)

  def get_item(self):
    id_s = self.f.readline().split(" ")[0]
    if(not id_s):
      return None
    seq = ""
    while True:
      position = self.f.tell()
      tempLine = self.f.readline()
      if(not tempLine):
        return Contig(id_s, seq)
      if(not tempLine.startswith(">")):
        seq = seq + tempLine
      else:
        self.f.seek(position)
        return Contig(id_s,seq)

class Contig:
  def __init__(self, id, seq):
    self.id = id[1:].strip()
    self.seq = seq
    self.predicted = dict()
    self.db = None

  def add_db(self, db):
    self.db = db

  def print_contig(self):
    output = list()
    output.extend(self.print_fh())
    output.extend(self.print_source())
    output.extend(self.print_cds())
    output.extend(self.print_seq())
    for line in output:
      print line

  def print_fh(self):
    lines = list()
    lines.append("FH   Key".ljust(SPACE) + "Location/Qualifiers")
    lines.append("FH".ljust(SPACE))
    return lines

  def print_source(self):
    lines = list()
    lines.append("FT   source".ljust(SPACE) + "1.." + str(len(self.seq)))
    lines.append("FT".ljust(SPACE) + "/origid=\"" + self.id + "\"")
    return lines

  def print_cds(self):
    lines = list()
    for pred in self.predicted:
      lines.append("FT   CDS".ljust(SPACE))
      lines.append("FT".ljust(SPACE) + "/locus_tag=\"" + self.predicted[pred].name + "\"")
      if( len(self.predicted[pred].blast_hits) == 0):
        lines.append("FT".ljust(SPACE) + "No BLAST Annotation")
      for hit in sorted(self.predicted[pred].blast_hits, key=lambda d: float(d["evalue"])):
        lines.append("FT".ljust(SPACE) + "/blast_hit=\"" + "complete_name: " + hit["db_name"] + " ID:\"" + hit["gene_name"] + "\"")
        self.db.get_annotation(hit["db_name"])
        break

      if( len(self.predicted[pred].pfam_hits) == 0):
        lines.append("FT".ljust(SPACE) + "No PFAM Annotation")
      else:
        hit = self.predicted[pred].pfam_hits[0]
        lines.append("FT".ljust(SPACE) + "/pfam_hit=\"" + "complete_name: " + hit["query_name"])
    return lines

  def print_seq(self):
    lines = list()
    lines.append("SQ   Sequence " + str(len(self.seq)) + " BP;")
    lines.append(self.seq)
    return lines
      

class Prediction:
  def __init__(self, name, line):
    splitLine = line.split()
    self.name = name.split(" ")[0] + "_" + splitLine[0]
    self.start = splitLine[1]
    self.stop = splitLine[2]
    self.blast_hits = list()
    self.pfam_hits = list()

def add_blast_results(filename, contigs):
  br = BlastResults(filename)
  while True:
    hit = br.get_item()
    if(not hit):
      break
    contig_name = hit["gene_name"].split("_")[0]
    prediction_name = hit["gene_name"]
    contigs[contig_name].predicted[prediction_name].blast_hits.append(hit)

def add_interpro_results(filename, contigs):
  pf = InterProResults(filename)
  while True:
    hit = pf.get_item()
    if(not hit):
      break
    contig_name = hit["query_name"].split("_")[0]
    prediction_name = hit["query_name"]
    contigs[contig_name].predicted[prediction_name].pfam_hits.append(hit)

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Create SQLite DBs from UniProt databases")

  parser.add_argument("-f", "--fasta", dest="contig", help="Contigs")
  parser.add_argument("-g", "--predicted", dest="pred", help="Predicted genes")
  parser.add_argument("-b", "--blast", dest="br", nargs='+', help="BLAST results", default=[])
  parser.add_argument("-s", "--sprot", dest="sprot", help="Sprot DB")
  parser.add_argument("-t", "--trembl", dest="trembl", help="Trembl DB")
  parser.add_argument("-i", "--interpro", dest="interpro", nargs='+', help="InterPro results", default=[])
  parser.add_argument("-o", "--output", dest="output", help="Output filename", default="result")

  args = parser.parse_args()

  contigs = dict()

  contig_file = InputResults(args.contig)

  db = BlastDB()
  if(args.sprot):
    db.add_db(args.sprot)
  if(args.trembl):
    db.add_db(args.trembl)

  while True:
    contig = contig_file.get_item()
    if(contig):
      contig.add_db(db)
      contigs[contig.id] = contig
    else:
      break

  pred_file = MgaResults(args.pred, contigs)
  while True:
    prediction = pred_file.get_item()
    if(not prediction):
      break
  
  for filename in args.br:
    add_blast_results(filename, contigs)

  for filename in args.interpro:
    add_interpro_results(filename, contigs)

  for con in contigs.keys():
    contigs[con].print_contig()
    pass
