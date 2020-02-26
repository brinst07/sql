동일한 SQL 문장이란 : 텍스트가 완벽하게 동일한 SQL
1. 대소문자 구별함
2. 공백도 동일 해야함
3. 조회결과가 같다고 동일한 SQL이 아님
4. 주석도 영향을 미친다.

그렇기 때문에 다음 SQL 문장은 동일한 문장이 아니다.

SELECT * FROM dept;
select * FROM dept;
select  * FROM dept;
select *
FROM dept;

SQL 실행시 v$SQL 뷰에 데이터가 조회되는지 확인
SELECT /* sql_test */ * 
FROM dept
WHERE deptno = 10;

--위 두개의 SQL은 검색하고자 하는 부서번호만 다르고 
--나머지 텍스트는 동일하다. 하지만 부서번호가 다르기 때문에
--DBMS입장에서는 서로 다른 SQL로 인식된다.
--> 다른 SQL 실행 계획을 세운다
--> 실행 계획을 공유하지 못한다.
--> 해결책 바인드 변수
--SQL에서 변경되는 부분을 별도로 전송을 하고
--실행계획 세워진 이후에 바인딩 작업을 거쳐
--실제 사용자가 원하는 변수 값으로 치환후 실행
--> 실행 계획을 공유 --> 메모리 자원 낭비 방지

SELECT /*sql_test*/ *
FROM dept
WHERE deptno = :deptno;

SQL 커서 : SQL 문을 실행하기 위한 메모리 공간
기존에 사용한 SQL문은 묵시적 커서를 사용.
로직을 제어하기 위한 커서 : 명시적 커서

SELECT 결과 여러건을 TABLE 타입의 변수에 저장할 수 있지만
메모리는 한정적이기 때문에 많은 양의 데이터를 담기에는 제한이 따름.

SQL 커서를 통해 개발자가 직접 데이터를 FETCH 함으로써 SELECT 결과를
전부 불러오지 않고도 개발이 가능. -> 자바의 리터레이터와 비슷하다

커서 선언 방법:
선언부(DECLARE)에서 선언
    CURSOR 커서이름 IS
        제어할 쿼리;
        
실행부(BEGIN)에서 커서 열기
    OPEN 커서이름
    
실행부(BEGIN)에서 커서로 부터 데이터 FETCH
    FETCH 커서이름 INTO 변수
    
실행부(BEGIN)에서 커서 닫기
    CLOSE 커서이름


부서테이블을 활용하여 모든 행에 대해 부서번호와 부서 이름을 CURSOR을 통해
FETCH, FETCH 된 결과를 확인

SET SERVEROUTPUT ON;

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;

BEGIN
    OPEN dept_cursor;
    
    LOOP
        
        
        FETCH dept_cursor INTO v_deptno, v_dname;
        
        EXIT WHEN dept_cursor%NOTFOUND; --조건을 확인하고 출력문 실행
        
        DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
    
        
        
    END LOOP; 
    
END;
/

SELECT *
FROM dept;

CURSOR를 열고 닫는 과정이 다소 거추장 스러움
CURSOR는 일반적으로 LOOP와 함께 사용하는 경우가 많음
==> 명시적 커서를 FOR LOOP에서 사용할 수 있게끔 문법으로 제공;

--List<String> userNameList = new ArrayList<String>();
--userNameList.add("brown");
--userNameList.add("cony");
--userNameList.add("sally");
--
--일반 for
--for(int i = 0; i<userNameList.size(); i++){
--    String userName = userNameList.get(i);
--}
--
--for(String userName : userNameList){
--    userName 값을 사용....
--}


java의 향상된 for 문과 유사하다.
FOR record_name(한행에 정보를 담을 변수이름 / 변수를 직접 선언안함) IN 커서이름 LOOP
    record_name. 컬럼명
END LOOP;


DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

--인자가 있는 명시적 커서
--기존 커서 선언방법
--    CURSOR 커서이름 IS
--        서브쿼리...
--        
--인자가 있는 커서 선언 방법
--    CURSOR 커서이름(인자1 인자1타입) IS
--        서브쿼리
--        (커서 선언시에 작성한 인자를 서브쿼리에서 사용할 수 있다.)
        
DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno, dname
        FROM dept
        WHERE deptno <= p_deptno;
BEGIN
    FOR rec IN dept_cursor(20) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/


인터페이스를 이용하여 객체를 생성가능한가?

FOR LOOP에서 커서를 인라인 형태로 작성
FOR 레코드이름 IN 커서이름
==>
FOR 레코드이름 IN (서브쿼리);


DECLARE

BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ' : ' || rec.dname);
    END LOOP;
END;
/

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

select *
FROM dt;

CREATE OR REPLACE PROCEDURE avgdt

BEGIN
   
    FOR i IN 0..(SELECT dt FROM dt) LOOP
    DBMS_OUTPUT.PUT_LINE(dt(i).dt - dt(i+1).dt);
    END LOOP;
END;
/


DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER
    v_dt_tab dt_tab;
    
BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;
    
    FOR i IN 1.. v_dt_tab.count-1 LOOP
    DBMS_OUTPUT.PUT_LINE(v_dt_tab(i).dt-v_dt_tab(i+1).dt);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER; --자바로 치면 배열
    v_dt_tab dt_tab;
    
    v_diff_sum NUMBER := 0;
BEGIN
    SELECT* BULK COLLECT INTO v_dt_tab
    FROM dt;
    
    --DT테이블에는 8행이 있는데 1~7번행 까지만 LOOP를 시행
    FOR i IN 1.. v_dt_tab.count-1 LOOP
       v_diff_sum := v_diff_sum + v_dt_tab(i).dt-v_dt_tab(i+1).dt;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_diff_sum/(v_dt_tab.count-1));
END;
/

EXEC avgdt;

--SQL로 풀어보면

SELECT AVG(a) a-- WINDOW FUNCTION은 다른 함수와 달리 중첩이 불가능하다. 따라서 이것을 서브쿼리로 FROM 절에 기술하고 SELECT해서 결과를 출력했다.
FROM
(SELECT LEAD(dt,1) OVER(ORDER BY dt) - dt as a
FROM dt);

--ROWNUM을 이용해서 푸는 방법 내가 직접 풀어보기

--MAX, MIN, COUNT (MAX-MIN)/COUNT

--커서로도 풀어보기

SELECT (MAX(dt) -MIN(dt))/(COUNT(dt)-1)
FROM dt;

--집합적 사고와 절차적사고를 둘다 해야한다. 