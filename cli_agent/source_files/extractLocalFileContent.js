import fs from 'fs';
import mammoth from 'mammoth';
import path from "path";

function isRemoteFile(filePath) {
    return /^https?:\/\//i.test(filePath);
}
async function extractWordAsHtml(filePath) {
    if (isRemoteFile(filePath)) {
    }else{
            const ext = path.extname(filePath).toLowerCase();            
            if (ext === ".docx") {
                const buffer = fs.readFileSync(filePath);
                const result = await mammoth.convertToHtml({ buffer });
                console.log(result.value); // HTML 内容
            }else if (ext === ".txt" || ext === ".md"){
                const content = fs.readFileSync(filePath, "utf-8");
            }
    }
}

extractWordAsHtml('/home/intel/test/gemini_work/test.md');
