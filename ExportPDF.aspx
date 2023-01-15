using System;
using System.Collections.Generic;
using System.Web;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Web.Script.Serialization;

namespace mms2document
{
    public partial class ExportPDF : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                try
                {
                    //名稱, 字體較大16
                    string documenttitle = Request.Form["documenttitle"];
                    var base64bytedocumenttitle = System.Convert.FromBase64String(documenttitle);
                    documenttitle = System.Text.Encoding.UTF8.GetString(base64bytedocumenttitle);
                    var objtitle = new JavaScriptSerializer().Deserialize<List<string>>(documenttitle);

                    //說明, 字體較小15
                    string documentdescription = Request.Form["documentdescription"];
                    var base64bytedocumentdescription = System.Convert.FromBase64String(documentdescription);
                    documentdescription = System.Text.Encoding.UTF8.GetString(base64bytedocumentdescription);
                    var objdescription = new JavaScriptSerializer().Deserialize<List<string>>(documentdescription);

                    //request參數sample,逗點分隔字串清單
                    string requestsample = Request.Form["requestsample"];
                    var base64byterequestsample = System.Convert.FromBase64String(requestsample);
                    requestsample = System.Text.Encoding.UTF8.GetString(base64byterequestsample);
                    var objrequestsample = new JavaScriptSerializer().Deserialize<List<string>>(requestsample);

                    //request參數欄位,json格式,轉表格式說明
                    string requeststring = Request.Form["requeststring"];
                    var base64byterequeststring = System.Convert.FromBase64String(requeststring);
                    requeststring = System.Text.Encoding.UTF8.GetString(base64byterequeststring);
                    var objrequeststrings = new JavaScriptSerializer().Deserialize<List<string>>(requeststring);

                    //response參數sample,逗點分隔字串清單
                    string responsesample = Request.Form["responsesample"];
                    var base64byteresponsesample = System.Convert.FromBase64String(responsesample);
                    responsesample = System.Text.Encoding.UTF8.GetString(base64byteresponsesample);
                    var objresponsesample = new JavaScriptSerializer().Deserialize<List<string>>(responsesample);

                    //response參數欄位,json格式,轉表格式說明
                    string responsestring = Request.Form["responsestring"];
                    var base64byteresponsestring = System.Convert.FromBase64String(responsestring);
                    responsestring = System.Text.Encoding.UTF8.GetString(base64byteresponsestring);
                    var objresponsestrings = new JavaScriptSerializer().Deserialize<List<string>>(responsestring);

                    //浮水印需要in,out處理
                    string temp_pdfnamein = new Guid().ToString() + "_in.pdf";
                    temp_pdfnamein = HttpContext.Current.Server.MapPath(temp_pdfnamein);
                    string temp_pdfnameout = new Guid().ToString() + "_out.pdf";
                    temp_pdfnameout = HttpContext.Current.Server.MapPath(temp_pdfnameout);

                    //檔案名稱
                    string downloadfilename = Request.Form["downloadfilename"];
                    if (downloadfilename == null) { downloadfilename = "API文件"; } else
                    {
                        var base64bytedownloadfilename = System.Convert.FromBase64String(downloadfilename);
                        downloadfilename = System.Text.Encoding.UTF8.GetString(base64bytedownloadfilename);
                    }

                    using (Document document = new Document(PageSize.A4))
                    {
                        using (PdfWriter writer = PdfWriter.GetInstance(document, new System.IO.FileStream(temp_pdfnamein, System.IO.FileMode.Create)))
                        {
                            document.Open();

                            //文件段落分為5部份, API說明(大小2種字體), 請求request內容, 請求request詳細說明表, 回覆response內容, 回覆response詳細說明表

                            string chFontPath = "c:\\windows\\fonts\\msjh.ttc,0"; //微軟正黑體                            
                            BaseFont chBaseFont = BaseFont.CreateFont(chFontPath, BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);

                            for (int index=0; index< objtitle.Count; index++)
                            {
                                
                                //API說明
                                var titlefont = new iTextSharp.text.Font(chBaseFont, 16, 0);
                                var titleParagraph = new Paragraph(26f, objtitle[index], titlefont);
                                //document.Add(titleParagraph);

                                //做書籤
                                Chapter chapter1 = new Chapter(new Paragraph(0f,"", new iTextSharp.text.Font(chBaseFont, 1, 0)), index);
                                chapter1.BookmarkTitle = objtitle[index];
                                chapter1.Add(titleParagraph);
                                document.Add(chapter1);

                                //說明
                                var descriptionfont = new iTextSharp.text.Font(chBaseFont, 15, 0);
                                var descriptionParagraph = new Paragraph(18f, objdescription[index], descriptionfont);
                                //descriptionParagraph.FirstLineIndent = 20f;
                                descriptionParagraph.IndentationLeft = 20f;
                                document.Add(descriptionParagraph);


                                //request內容 
                                var cellFont = new iTextSharp.text.Font(chBaseFont, 12, 0);
                                PdfPTable table = new PdfPTable(1);
                                table.TotalWidth = 500f;
                                table.LockedWidth = true;
                                float[] widths = new float[] { 1f };
                                table.SetWidths(widths);
                                table.SpacingBefore = 14f;
                                table.SpacingAfter = 2f;

                                PdfPCell cell = new PdfPCell(new Phrase("一.request", cellFont));
                                cell.Border = 0;
                                cell.PaddingBottom = 10;
                                table.AddCell(cell);

                                table.DefaultCell.PaddingBottom = 10;
                                table.AddCell(objrequestsample[index].Replace("～", "\""));

                                document.Add(table);

                                //reqest說明,表格(欄位,必填,類型,說明)
                                table = new PdfPTable(4);
                                table.TotalWidth = 500f;
                                table.LockedWidth = true;
                                widths = new float[] { 2f, 0.5f, 0.7f, 4f };
                                table.SetWidths(widths);
                                table.DefaultCell.PaddingBottom = 8;
                                table.SpacingBefore = 2f;
                                table.SpacingAfter = 14f;

                                string[] tableheader = { "欄位", "必填", "類型", "說明" };
                                for (int i = 0; i < tableheader.Length; i++)
                                {
                                    if (i == 1 || i == 2)
                                    {
                                        PdfPCell cell1 = new PdfPCell(new Phrase(tableheader[i], cellFont));
                                        cell1.HorizontalAlignment = Element.ALIGN_CENTER;
                                        table.AddCell(cell1);
                                    }
                                    else
                                    {
                                        table.AddCell(new Phrase(tableheader[i], cellFont));
                                    }
                                }

                                requeststring = objrequeststrings[index].Replace("～", "\"");
                                var objrequeststring = new JavaScriptSerializer().Deserialize<List<detailtable>>(requeststring);
                                for (int i = 0; i < objrequeststring.Count; i++)
                                {
                                    table.AddCell(new Phrase(objrequeststring[i].header, cellFont));                                   
                                    PdfPCell cell2 = new PdfPCell(new Phrase(objrequeststring[i].ismust, cellFont));
                                    cell2.HorizontalAlignment = Element.ALIGN_CENTER;
                                    table.AddCell(cell2);
                                    PdfPCell cell3 = new PdfPCell(new Phrase(objrequeststring[i].datatype, cellFont));
                                    cell3.HorizontalAlignment = Element.ALIGN_CENTER;
                                    table.AddCell(cell3);
                                    table.AddCell(new Phrase(objrequeststring[i].description, cellFont));
                                }

                                document.Add(table);


                                //response內容 
                                table = new PdfPTable(1);
                                table.TotalWidth = 500f;
                                table.LockedWidth = true;
                                widths = new float[] { 1f };
                                table.SetWidths(widths);
                                table.SpacingBefore = 14f;
                                table.SpacingAfter = 2f;

                                cell = new PdfPCell(new Phrase("二.response", cellFont));
                                cell.Border = 0;
                                cell.PaddingBottom = 10;
                                table.AddCell(cell);

                                table.DefaultCell.PaddingBottom = 10;
                                table.AddCell(objresponsesample[index].Replace("～", "\""));

                                document.Add(table);

                                //response說明,表格(欄位,必填,類型,說明)
                                table = new PdfPTable(4);
                                table.TotalWidth = 500f;
                                table.LockedWidth = true;
                                widths = new float[] { 2f, 0.5f, 0.7f, 4f };
                                table.SetWidths(widths);
                                table.DefaultCell.PaddingBottom = 8;
                                table.SpacingBefore = 2f;
                                table.SpacingAfter = 14f;

                                for (int i = 0; i < tableheader.Length; i++)
                                {
                                    if (i==1 || i == 2)
                                    {
                                        PdfPCell cell1 = new PdfPCell(new Phrase(tableheader[i], cellFont));
                                        cell1.HorizontalAlignment = Element.ALIGN_CENTER;
                                        table.AddCell(cell1);
                                    } else
                                    {
                                        table.AddCell(new Phrase(tableheader[i], cellFont));
                                    }
                                }

                                responsestring = objresponsestrings[index].Replace("～", "\"");
                                var objresponsestring = new JavaScriptSerializer().Deserialize<List<detailtable>>(responsestring);
                                for (int i = 0; i < objresponsestring.Count; i++)
                                {
                                    table.AddCell(new Phrase(objresponsestring[i].header, cellFont));
                                    PdfPCell cell2 = new PdfPCell(new Phrase(objresponsestring[i].ismust, cellFont));
                                    cell2.HorizontalAlignment = Element.ALIGN_CENTER;
                                    table.AddCell(cell2);
                                    PdfPCell cell3 = new PdfPCell(new Phrase(objresponsestring[i].datatype, cellFont));
                                    cell3.HorizontalAlignment = Element.ALIGN_CENTER;
                                    table.AddCell(cell3);
                                    table.AddCell(new Phrase(objresponsestring[i].description, cellFont));
                                }

                                document.Add(table);
                                


                            }



                            document.Close();
                        }
                    }


                    //浮水印,頁碼
                    PdfReader pdfreader = new PdfReader(temp_pdfnamein);
                    System.IO.FileStream fileout = new System.IO.FileStream(temp_pdfnameout, System.IO.FileMode.Create, System.IO.FileAccess.Write);
                    PdfStamper stamper = new PdfStamper(pdfreader, fileout);
                    PdfGState pdfgstate = new PdfGState()
                    {
                        FillOpacity = 0.2f,
                        StrokeOpacity = 0.5f
                    };
                    int pages = pdfreader.NumberOfPages;
                    for (int i = 1; i <= pages; i++)
                    {
                        PdfContentByte over = stamper.GetOverContent(i);
                        over.SetGState(pdfgstate);
                        iTextSharp.text.Rectangle pageRect = pdfreader.GetPageSize(i);

                        for (int y = 40; y < pageRect.Height; y = y + 250)
                        {
                            for (int x = 50; x < pageRect.Width; x = x + 250)
                            {
                                ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER, new Phrase("copyright"), x, y, 45);
                            }
                        }
                        ColumnText.ShowTextAligned(stamper.GetUnderContent(i), Element.ALIGN_RIGHT, new Phrase(i.ToString()), pageRect.Width-20, 15f, 0);
                    }
                    stamper.Close();
                    pdfreader.Close();
                    fileout.Close();


                    //下載
                    using (System.IO.MemoryStream stream = new System.IO.MemoryStream())
                    {
                        using (System.IO.FileStream file = new System.IO.FileStream(temp_pdfnameout, System.IO.FileMode.Open, System.IO.FileAccess.Read))
                        {
                            byte[] bytes = new byte[file.Length];
                            file.Read(bytes, 0, (int)file.Length);
                            stream.Write(bytes, 0, (int)file.Length);

                            System.Web.HttpContext.Current.Response.Clear();
                            System.Web.HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + System.Web.HttpUtility.UrlEncode(downloadfilename) + ".pdf");
                            System.Web.HttpContext.Current.Response.ContentType = "application/octet-stream";
                            System.Web.HttpContext.Current.Response.BinaryWrite(stream.ToArray());
                        }
                        if (System.IO.File.Exists(temp_pdfnamein)) System.IO.File.Delete(temp_pdfnamein);
                        if (System.IO.File.Exists(temp_pdfnameout)) System.IO.File.Delete(temp_pdfnameout);
                    }
                }
                catch (Exception ex)
                {
                    Response.Write(ex.Message);
                }
                finally
                {
                    System.Web.HttpContext.Current.Response.Flush();
                    System.Web.HttpContext.Current.Response.End();
                }
            }
        }
    }
    public class detailtable
    {
        public string header { get; set; }
        public string ismust { get; set; }
        public string datatype { get; set; }
        public string description { get; set; }
    }

}
