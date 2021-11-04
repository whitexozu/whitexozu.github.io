---
title: '[google drive api] 파일 생성, 권한 추가 사용 방법 조사'
date: 2020-06-02 08:05:34
author: TMM
categories: OpenAPI
tags: Google Drive API
---

spreadsheet를 생성 및 사용 후 다른 사람과 공유를 해야하는 경우가 생겼습니다. 그래서 리서치 중 구글 드라이브 API를 사용하면 가능하다는 글을 보게되어 테스트 해보겠습니다.

## 목표

1. API 계정에서 스프레드시트 생성
1. API 계정에서 스프레드시트 공유
1. 공유 계정에서 스프레드시트 확인
1. API 계정에서 스프레드시트 수정
1. 공유 계정에서 스프레드시트 수정 내용 확인

## 개발 환경

- Java 1.8, Spring-boot, Maven

## 순서

1. GCP Console 설정

   1. GCP 프로젝트 생성
   1. 서비스 계정 생성 및 권한 설정

      1. IAM 및 관리자 > 서비스 계정 > 서비스 계정 만들기(이름 입력 후 권한을 `편집자` 선택)
      1. IAM 및 관리자 > 서비스 계정 > 생성된 이메일 클릭 > 키 탭 클릭 > 키 추가 > 새 키 만들기 > JSON 선택

   1. API 및 서비스 추가

      - 사용할 API 추가

      1. API 및 서비스
      1. 대시보드 > API 및 서비스 사용 설정 > Google Drive API > 사용
      1. 대시보드 > API 및 서비스 사용 설정 > Google Sheets API > 사용

   1. 사용자 인증 정보 생성

      - 사용 설정한 API에 액세스하려면 사용자 인증 정보

      1. API 및 서비스 > 사용자 인증 정보 > 사용자 인증 정보 만들기 > OAuth 클라이언트 ID > 동의 화면 구성 > 내부/외부 선택(저는 개인 사용자이므로 외부를 선택했습니다) > 만들기
         1. 앱정보 입력 > 저장 후 계속
         1. 범위 추가 또는 삭제 > 하기 내용 선택 > 저장 후 계속
            - .../auth/drive\*
            - .../auth/spreadsheets\*
         1. 테스트 사용자 추가 하지 않고 저장 후 계속
         1. 요약 확인 후 대시보드로 돌아가기
      1. 사용자 인증 정보 > 사용자 인증 정보 만들기 > OAuth 클라이언트 ID > 애플리케이션 유형 선택(테스트콥 앱) > 이름 입력(AGA 으로 지었습니다) > 만들기
      1. 사용자 인증 정보의 `OAuth 2.0 클라이언트 ID` 목록에 추가된 ID 확인

1. 소스 작성

   1. pom.추가

      ```xml
      <!-- https://mvnrepository.com/artifact/com.google.api-client/google-api-client -->
      <dependency>
          <groupId>com.google.api-client</groupId>
          <artifactId>google-api-client</artifactId>
          <version>1.30.4</version>
      </dependency>

      <!-- https://mvnrepository.com/artifact/com.google.oauth-client/google-oauth-client -->
      <dependency>
          <groupId>com.google.oauth-client</groupId>
          <artifactId>google-oauth-client</artifactId>
          <version>1.30.4</version>
      </dependency>

      <!-- https://mvnrepository.com/artifact/com.google.apis/google-api-services-sheets -->
      <dependency>
          <groupId>com.google.apis</groupId>
          <artifactId>google-api-services-sheets</artifactId>
          <version>v4-rev581-1.25.0</version>
      </dependency>

      <!-- https://mvnrepository.com/artifact/com.google.api-client/google-api-client-extensions -->
      <dependency>
          <groupId>com.google.api-client</groupId>
          <artifactId>google-api-client-extensions</artifactId>
          <version>1.6.0-beta</version>
      </dependency>

      <!-- https://mvnrepository.com/artifact/com.google.apis/google-api-services-drive -->
      <dependency>
          <groupId>com.google.apis</groupId>
          <artifactId>google-api-services-drive</artifactId>
          <version>v3-rev197-1.25.0</version>
      </dependency>

      <!-- https://mvnrepository.com/artifact/com.google.oauth-client/google-oauth-client-jetty -->
      <dependency>
          <groupId>com.google.oauth-client</groupId>
          <artifactId>google-oauth-client-jetty</artifactId>
          <version>1.23.0</version>
      </dependency>
      ```

   1. import

      ```java
      import com.google.api.client.googleapis.batch.BatchRequest;
      import com.google.api.client.googleapis.batch.json.JsonBatchCallback;
      import com.google.api.client.googleapis.json.GoogleJsonError;
      import com.google.api.client.http.HttpHeaders;
      import com.google.api.services.drive.Drive;
      import com.google.api.services.drive.model.File;
      import com.google.api.services.drive.model.FileList;
      import com.google.api.services.drive.model.Permission;


      import com.google.api.services.sheets.v4.Sheets;
      import com.google.api.services.sheets.v4.model.AppendValuesResponse;
      import com.google.api.services.sheets.v4.model.BatchUpdateSpreadsheetRequest;
      import com.google.api.services.sheets.v4.model.BatchUpdateSpreadsheetResponse;
      import com.google.api.services.sheets.v4.model.FindReplaceRequest;
      import com.google.api.services.sheets.v4.model.FindReplaceResponse;
      import com.google.api.services.sheets.v4.model.GridRange;
      import com.google.api.services.sheets.v4.model.Request;
      import com.google.api.services.sheets.v4.model.Sheet;
      import com.google.api.services.sheets.v4.model.Spreadsheet;
      import com.google.api.services.sheets.v4.model.SpreadsheetProperties;
      import com.google.api.services.sheets.v4.model.UpdateValuesResponse;
      import com.google.api.services.sheets.v4.model.ValueRange;
      ```

   1. 스프레드시트 생성

      ```java
      @PostMapping("create")
      public Object create(@ModelAttribute SheetsDTO dto) {
          try {
              Spreadsheet spreadsheet = new Spreadsheet()
                  .setProperties(new SpreadsheetProperties().setTitle("api-bot-1-spreadsheet-1"));

              // default sheet name is Sheet1
              Sheets service = googleAPIClient.getSheets();

              spreadsheet = service.spreadsheets().create(spreadsheet)
                      .setFields("spreadsheetId")
                      .execute();

              log.debug("Spreadsheet ID : {}", spreadsheet.getSpreadsheetId());

          } catch (Exception e) {
              e.printStackTrace();
          }

          return ResultGenerator.generateList(ErrorCode.ok, null);
      }
      ```

   1. 스프레드시트 공유

      ```java
      @PostMapping("/appendPermission")
      public Object appendPermission() {
          try {
              final String spreadsheetId = "[Spreadsheet ID]";

              JsonBatchCallback<Permission> callback = new JsonBatchCallback<Permission>() {
                  @Override
                  public void onFailure(GoogleJsonError e, HttpHeaders responseHeaders) throws IOException {
                      // Handle error
                      log.error("{}", e.getMessage());
                  }

                  @Override
                  public void onSuccess(Permission permission, HttpHeaders responseHeaders) throws IOException {
                      log.info("Permission ID: " + permission.getId());
                  }
              };
              Drive service = googleAPIClient.getDirve();
              BatchRequest batch = service.batch();

              Permission userPermissionWriter = new Permission().setType("user").setRole("writer").setEmailAddress("[공유 이메일 주소]");
              service.permissions().create(spreadsheetId, userPermissionWriter).setFields("id").queue(batch, callback);

              Permission userPermissionReader = new Permission().setType("user").setRole("reader").setEmailAddress("[공유 이메일 주소]");
              service.permissions().create(spreadsheetId, userPermissionReader).setFields("id").queue(batch, callback);

              batch.execute();
          } catch (Exception e) {
              e.printStackTrace();
          }

          return ResultGenerator.generateList(ErrorCode.ok, null);
      }
      ```

   1. 스프레드시트 수정

      ```java
      @PostMapping("/write")
      public Object SheetWrite(@RequestBody SheetsDTO dto) {
          try {
              log.debug("sheets write job_type: {}", dto.getJob_type());
              log.debug("sheets write spradsheet_id: {}", dto.getSpreadsheet_id());
              log.debug("sheets write sheet_name: {}", dto.getSheet_name());
              log.debug("sheets write sheet_range: {}", dto.getSheet_range());
              log.debug("sheets write insert_dataset: {}", dto.getInsert_dataset());

              final String spreadsheetId = dto.getSpreadsheet_id();
              final String sheetName = dto.getSheet_name();
              final String sheetRange = dto.getSheet_range();
              final String insertDateset = dto.getInsert_dataset();

              Sheets service = googleAPIClient.getSheets();

              log.debug(String.format("%s!%s", sheetName, sheetRange));

              List<List<Object>> values = Arrays.asList(
                  Arrays.asList(insertDateset.split("\\s*,\\s*")));

              ValueRange body = new ValueRange()
                  .setValues(values);
              UpdateValuesResponse result =
                  service.spreadsheets().values().update(spreadsheetId, String.format("%s!%s", sheetName, sheetRange), body)
                  .setValueInputOption("USER_ENTERED")
                  .execute();
              log.debug("{} cells updated.", result.getUpdatedCells());
              dto.setWrite_count(result.getUpdatedCells());

          } catch (Exception e) {
              e.printStackTrace();
          }

          return ResultGenerator.generateObject(ErrorCode.ok, dto);
      }
      ```

```toc

```
