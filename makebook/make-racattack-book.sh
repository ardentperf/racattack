cd src
python3.2 all.py http://en.wikibooks.org/wiki/RAC_Attack_-_Oracle_Cluster_Database_at_Home/Print_Book

cd ../document/main
cp main.tex main.tex.orig; awk '
 /Exclude_in_print/{next} 
 /UNKNOWN TEMPLATE/{ut=$0;next} 
 /Sidebox/,/\\end{myenumerate}/{ut="";gotsidebox=1;next} 
 gotsidebox{gotsidebox=0;next}
 ut{print(ut);ut=""};
 {
   if(/^\\begin{minipage}/&&!rightafterimage){
     sub(/^/,"\\nopagebreak\\centerline{");
     sub(/$/,"\\vspace{0.1cm}");
   };
   sub(/^Next on .* track: .*/,"");  # remove these links from end of "Create Cluster" chapter
   sub(/^Previous on .* track: .*/,"");  # remove these links from end of "RAC Install" chapter
   sub(/^\\begin{minipage}/,"\\centerline{\\begin{minipage}");
   sub(/^\\end{minipage}/,"\\end{minipage}}");
   sub(/\\vspace{0.75cm}/,"\\vspace{0.5cm}");
   gsub(/\\item{}\\item{}/,"\\item{}");  # wiki sometimes has <li></li><li> for web formatting
   gsub(/\\myplainurl{http[s]?:\/\/}/,"");
   gsub(/\\begin{minipage}{1.0\\linewidth}/,"\\begin{minipage}{0.7\\linewidth}");
   print
 }
 /./{rightafterimage=0}
 /\\end{minipage}/{rightafterimage=1}
' main.tex.orig >main.tex

pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex

cp -v main.pdf ~/racattack.pdf

