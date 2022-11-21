using System.IO;
using System.Collections.Generic;
using System.Text.Json;
using System.Linq;

namespace Soru3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            IList<InvoiceDetail> sourceList = new List<InvoiceDetail>();
            using (StreamReader r = new StreamReader("response.json"))
            {
                string json = r.ReadToEnd();
                sourceList = JsonSerializer.Deserialize<IList<InvoiceDetail>>(json);

                //Satırları küçükten büyüğe sıralayarak kontorllerimizi satır sırasına göre yapıyoruz.
                sourceList = sourceList.OrderBy(x => x.boundingPoly.vertices[0].y).ToList();

                //Hangi satırda olduğumuzu anlayabilmek için bir referans değeri belirliyoruz.
                var lineReferanceYValue = sourceList.FirstOrDefault().boundingPoly.vertices[0].y;

                //Değerleri satır bazında gruplara ayırıyoruz.
                IList<Line> lines = new List<Line>();
                Line line = new Line();
                foreach (var item in sourceList.Skip(1))
                {
                    var itemLeftTopYValue = item.boundingPoly.vertices[0].y;
                    //Aynı grupta olduğunu +-10 sapma payı ile kontrol ediyoruz.
                    if (itemLeftTopYValue < lineReferanceYValue + 10 && itemLeftTopYValue > lineReferanceYValue - 10)
                    {
                        Column column = new Column();
                        column.X = item.boundingPoly.vertices[0].x;
                        column.Description = item.description;
                        line.Columns.Add(column);
                    }
                    else
                    {
                        lines.Add(line);
                        line = new Line();
                        Column column = new Column();
                        column.X = item.boundingPoly.vertices[0].x;
                        column.Description = item.description;
                        line.Columns.Add(column);
                        lineReferanceYValue = itemLeftTopYValue;
                    }
                }
                lines.Add(line);

                //Dosyaya yazabilmek ve Sütun bazında sıralayabilmek için döngüye sokuyoruz.
                IList<string> textLines = new List<string>();
                foreach (var item in lines)
                {
                    string textline = "";
                    var columns = item.Columns.OrderBy(x => x.X).ToList();
                    foreach (var column in columns)
                    {
                        textline += column.Description + " ";
                    }
                    textLines.Add(textline);
                }

                File.WriteAllLines("result.txt", textLines);
            }
        }
    }

    public class Invoice
    {
        public IList<InvoiceDetail> InvoiceDetail { get; set; }
    }
    public class InvoiceDetail
    {
        public string locale { get; set; }
        public string description { get; set; }
        public BoundingPoly boundingPoly { get; set; }

    }
    public class BoundingPoly
    {
        public IList<Vertice> vertices { get; set; }
    }
    public class Vertice
    {
        public int x { get; set; }
        public int y { get; set; }
    }

    public class Line
    {
        public IList<Column> Columns = new List<Column>();
    }

    public class Column
    {
        public int X { get; set; }
        public string Description { get; set; }
    }


}
