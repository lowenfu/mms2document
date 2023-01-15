# mms2document
reference postman make api document 

## 使用itext, 作成pdf檔, 文件版面分為5個區塊, 如下所示

title,subject... here

request

```
{         
  act:"getno",
  para:{ 
    name: "orders",
  }         
}         
```

|欄位|必填|類型|說明|
|----|----|----|----|
| act | Y | string | api方法... |
| name | Y | string | api對象... |

response 

```
{         
  errorstatus:"0",
  errormsg: "",
  remark: "",
}         
```

|欄位|必填|類型|說明|
|----|----|----|----|
| errorcode | Y | string | 0 success,1 error |
| errormsg | Y | string |   |
| remark | Y | string |  return data |

## 測試範例

```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title></title>
</head>
<body>
    <form action="ExportPDF.aspx" method="POST" id="postForm" name="postForm">
        <textarea id="documenttitle" name="documenttitle"></textarea>
        <textarea id="documentdescription" name="documentdescription"></textarea>
        <textarea id="requestsample" name="requestsample"></textarea>
        <textarea id="requeststring" name="requeststring"></textarea>
        <textarea id="responsesample" name="responsesample"></textarea>
        <textarea id="responsestring" name="responsestring"></textarea>
        <textarea id="downloadfilename" name="downloadfilename"></textarea>

        <input type="submit" value="Submit">
    </form>
    <script>
        var documenttitle = document.getElementById("documenttitle");
        documenttitle.value = window.btoa(unescape(encodeURIComponent('["api 1","api 2"]')));

        var documentdescription = document.getElementById("documentdescription");
        documentdescription.value = window.btoa(unescape(encodeURIComponent('["api 1...","api 2..."]')));

        var requestsample = document.getElementById("requestsample");
        var test1 = '[{\n "act": "getno",\n  "param":\n {\n  "name": "001"\n }},{\n "act": "gethello",\n  "param":\n {\n  "name": "002"\n }}]';
        test1 = test1.replace(/"/g, "～");
        requestsample.value = window.btoa(unescape(encodeURIComponent(test1)));

        var requeststring = document.getElementById("requeststring");
        var test2 = '["[{"header":"name","ismust":"Y","datatype":"string","description":"api對象"},]","[{"header":"name","ismust":"Y","datatype":"string","description":"api對象"},]"]';
        test2 = test2.replace(/"/g, "～");
        requeststring.value = window.btoa(unescape(encodeURIComponent(test2)));

        var responsesample = document.getElementById("responsesample");
        var test3 = '[{"errorcode":"1","errormsg":"網路中斷","remark":null},{"errorcode":"0","errormsg":"","remark":"hello"}]';
        test3 = test3.replace(/"/g, "～");
        responsesample.value = window.btoa(unescape(encodeURIComponent(test3)));

        var responsestring = document.getElementById("responsestring");
        var test4 = '["[{"header":"errorcode","ismust":"Y","datatype":"string","description":"1正常,-1錯誤"}, {"header":"errormsg","ismust":"Y","datatype":"string","description":"錯誤訊息"},{"header":"remark","ismust":"Y","datatype":"string","description":"null無傳回值"},
        ]","[{"header":"errorcode","ismust":"Y","datatype":"string","description":"1正常,-1錯誤"}, {"header":"errormsg","ismust":"Y","datatype":"string","description":"錯誤訊息"},{"header":"remark","ismust":"Y","datatype":"string","description":"回傳hello"}]"]';
        test4 = test4.replace(/"/g, "～");
        responsestring.value = window.btoa(unescape(encodeURIComponent(test4)));

        var downloadfilename = document.getElementById("downloadfilename");
        downloadfilename.value = window.btoa(unescape(encodeURIComponent("測試")));


    </script>

</body>
</html>
```
