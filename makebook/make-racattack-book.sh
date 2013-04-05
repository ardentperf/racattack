cd wb2pdf/trunk

cd src
python3.2 all.py http://en.wikibooks.org/wiki/RAC_Attack_-_Oracle_Cluster_Database_at_Home/Print_Book

cd ../document/main
cp main.tex main.tex.orig; awk '
 {
   # first, lots of tweaks to image typesetting
   # - center images with \centerline
   # - insert 0.1cm space above and change space below to 0.5cm
   # - keep image with previous paragraph unless it was immediately preceded by another image
   # - shrink full width images to 70% of their width (so that two screenshots can fit on one page)
   if(/^\\begin{minipage}/&&!rightafterimage){
     sub(/^/,"\\nopagebreak\\centerline{");
     sub(/$/,"\\vspace{0.1cm}");
   };
   sub(/^\\begin{minipage}/,"\\centerline{\\begin{minipage}");
   sub(/^\\end{minipage}/,"\\end{minipage}}");
   sub(/\\vspace{0.75cm}/,"\\vspace{0.5cm}");
   gsub(/\\begin{minipage}{1.0\\linewidth}/,"\\begin{minipage}{0.7\\linewidth}");
   # wikibook pages sometimes have <li></li><li> for web formatting
   gsub(/\\item{}\\item{}/,"\\item{}");
   # wb2pdf scatters spurious "http[s]://" whenever theres a link in an infobox
   gsub(/\\myplainurl{http[s]?:\/\/}/,"");
   print
 }
 /./{rightafterimage=0}
 /\\end{minipage}/{rightafterimage=1}
' main.tex.orig >main.tex

pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex

cp -v main.pdf ~/racattack.pdf

