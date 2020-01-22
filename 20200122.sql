--1
SELECT *
FROM LPROD;

--2
SELECT BUYER_ID, BUYER_NAME
FROM BUYER;

--3
SELECT*
FROM CART;

--4
SELECT MEM_ID, MEM_PASS, MEM_NAME
FROM member;

SELECT mem_id, mem_pass, mem_name
from member;

SELECT *
FROM users;

--테이블에 어떤 컬럼이 있는지 확인하는 방법
-- 1. SELECT * -> 다 검색해서 확인하기
-- 2. TOOL의 기능 (사용자-TABLES)
-- 3. DESC 테이블명 (DESC-DESCRIBE)

DESC users;

SELECT userid as u_id,usernm, reg_dt+5 reg_dt_after_5day
FROM users;

--날짜 연산 (reg_dt 컬럼은 date 정보를 담을 수 있는 타입)
--SQL 날짜 컬럼 + (더하기 연산)
--수학적인 사칙연산이 아닌것들(5+5)
--String h = "hello";
--String w = "world";
--String hw = h+w; --자바에서는 두 문자열을 결합
--SQL에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일자로 취급하여 더한다.
--reg_dt : 등록일짜 컬럼
--null : 값을 모르는 상태
--null에 대한 연산 결과는 항상 null

SELECT prod_id as id , prod_name as name
FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

SELECT buyer_id 바이어아이디 , buyer_name 이름
FROM buyer;

--문자열 결합
--자바 언어에서 문자열 결합 : +
--SQL에서는 : || ('Hello' || 'world')
--SQL에서는 : concat('Hello','world')

SELECT userid || usernm AS id_name
FROM users;

SELECT CONCAT(userid,usernm) AS id_name
FROM users;

--SQL에서의 변수는 없다.(컬럼이 비슷한 역할, pl/sql에는 변수 개념이 존재)
--SQL에서 문자열 상수는 싱글 쿼테이션으로 표현
-- "Hello, World" --> 'Hello, world'

--문자열 상수와 컬럼간의 결합
--user id : brown
--user id : cony
--별칭에는 공백이 들어갈 수 없다.
SELECT 'user id : '|| userid AS "Use rid "
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';'AS QUERY 
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT * FROM ' , table_name),';') AS QUERY
FROM user_tables;
--CONCAT(arg1, arg2)

--자바에서는 =가 할당 대입연산자이다
--if(a ==5) a의 값이 5인지 비교
--sql에서 =는 equal의 개념이다. sql에서는 대입의 개념이 없으나 pl/sql에 존재한다.

--users의 테이블의 모든 행에 대해서 조회
--users에는 5건의 데이터가 존재
SELECT *
FROM users;

--WHERE 절 : 테이블에서 데이터를 조회할 때 조건에 맞는 ROW(행)을 조회
--ex : userid 컬럼의 값이 brown인 행만 조회
-- brown과 'brown'을 구분할줄 알아야한다.
-- brown은 컬럼, 'brown'은 문자열 상수로 인식한다.
SELECT *
FROM users
WHERE userid = 'brown';

SELECT *
FROM users
WHERE userid <> 'brown';

SELECT *
FROM users
WHERE userid != 'brown';


DESC emp;

SELECT *
FROM emp;

SELECT *
FROM emp
WHERE ename = 'JONES';

SELECT *
FROM emp
WHERE COMM is not null;

desc emp; --employee

--5 > 10 FALSE
--5>5 FALSE
--5>=5 TRUE
-- emp 테이블에서 deptno(부서번호)가 30보다 크거나 같은 사원들만

SELECT *
FROM emp
WHERE deptno>= 30;
-- 숫자는 '를 붙이지 않아도 된다.

-- 문자열 : '문자열
-- 숫자 : 50
-- 날짜 : ??? --> 함수랑 문자열을 결합해서 표현한다. 문자열만 이용하여 표현가능하지만 권장하지않는다. 
-- 왜냐하면 국가별로 날짜 표기 방법이 다르기 때문이다.
-- 한국 : 년도4자리 -월 2가지-일자2자리 이지만 다른나라는 다르게 표현하는 나라들이 많다.
-- 입사일자가 1980년 12월 17일 직원만 조회

SELECT *
FROM emp
WHERE hiredate = '80/12/17';

--TO_DATE : 문자열을 date 타입으로 변경하는 함수
--TO_DATE (날짜형식 문자열, 첫번째 인자의 형식)

SELECT *
FROM emp
WHERE hiredate = TO_DATE('19801217', 'YYYYMMDD');

--범위연산 and, or 연산자
SELECT *
FROM emp
WHERE sal>=1000 AND sal<=2000 AND deptno = 30;

--범위연산자를 부등호 대신에 BETWEEN AND 연산자로 대체
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal in(1300,5000);

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101','YYYYMMDD'); 