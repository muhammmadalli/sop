import csv

def csv_to_vcf(csv_file, vcf_file):
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        with open(vcf_file, 'w', encoding='utf-8') as vcf:
            for row in reader:
                vcf.write("BEGIN:VCARD\n")
                vcf.write("VERSION:3.0\n")
                vcf.write(f"FN:{row['FN']}\n")
                if row.get('TEL;CELL'):
                    vcf.write(f"TEL;TYPE=CELL:{row['TEL;CELL']}\n")
                if row.get('TEL;X-DEFCOM'):
                    vcf.write(f"TEL;TYPE=X-LANDLINE:{row['TEL;X-LANDLINE']}\n")
                if row.get('X-JABBER;HOME'):
                    vcf.write(f"X-JABBER;TYPE=WORK:{row['X-JABBER;HOME']}\n")
                vcf.write("END:VCARD\n\n")

csv_to_vcf('contacts.csv', 'contacts.vcf')
