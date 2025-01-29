package utils;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.util.*;
public class ReadExcel {
    public static List<Map<String, Object>> readExcel(String filePath, String sheetName) {
        List<Map<String, Object>> dataList = new ArrayList<>();

        try (FileInputStream file = new FileInputStream(new File(filePath));
             Workbook workbook = new XSSFWorkbook(file)) {

            Sheet sheet = workbook.getSheet(sheetName);
            if (sheet == null) {
                throw new IllegalArgumentException("No se encontró la hoja: " + sheetName);
            }

            Row headerRow = sheet.getRow(0);
            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(cell.getStringCellValue());
            }

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                Map<String, Object> rowData = new HashMap<>();
                for (int j = 0; j < headers.size(); j++) {
                    Cell cell = row.getCell(j);
                    if (cell != null) {
                        switch (cell.getCellType()) {
                            case STRING:
                                rowData.put(headers.get(j), cell.getStringCellValue());
                                break;
                            case NUMERIC:
                                rowData.put(headers.get(j), cell.getNumericCellValue());
                                break;
                            case BOOLEAN:
                                rowData.put(headers.get(j), cell.getBooleanCellValue());
                                break;
                            default:
                                rowData.put(headers.get(j), null);
                        }
                    }
                }
                dataList.add(rowData);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error al leer el archivo Excel: " + e.getMessage(), e);
        }
        return dataList;
    }

    public static String readExcelAsJson(String filePath, String sheetName) {
        List<Map<String, Object>> data = readExcel(filePath, sheetName);
        try {
            return new ObjectMapper().writeValueAsString(data);
        } catch (Exception e) {
            throw new RuntimeException("Error al convertir datos a JSON: " + e.getMessage(), e);
 }
}


}