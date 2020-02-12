--제약조건확인방법
--    1. tool
--    2. dictionary view
--    제약조건 : USER_CONSTRAINTS
--    제약조건-컬럼 : USER_CONS_COLUMNS
--    제약조건이 몇개의 컬럼에 관련되어 있는지 알수 없기 때문
--    1정규화

-- fk 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스(uk,pk가 있어야 인덱스 생성)가 존재해야한다.

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP','DEPT','EMP_TEST','DEPT_TEST');

--EMP, DEPT PK, FK 제약이 존재하지 않음

ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);


SELECT *
FROM member;

--테이블, 컬럼 주석 : DICTIONARY 확인 가능
--테이블 주석 : USER_TAB_COMMENTS
--컬럼 주석 : USER_COL_COMMENTS
--주석 생성 
--테이블 주석: COMMENT ON TABLE 테이블명 IS '주석';
--컬럼 주석 : COMMENT ON COLUMN 테이블.컬럼 IS '주석';

--emp : 직원
--dept : 부서


COMMENT ON TABLE emp IS '직원';
COMMENT ON TABLE dept IS '부서';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');

--DEPT    DEPTNO : 부서번호
--DEPT    DNAME : 부서명
--DEPT    LOC : 부서위치
--EMP     EMPNO : 직원번호
--EMP     ENAM :  직원이름
--EMP     JOB   : 담당업무
--EMP     MGR  : 매니저 직원번호
--EMP     HIREDATE : 입사일자
--EMP     SAL  :  급여
--EMP     COMM  :  성과급
--EMP     DEPTNO  : 소속부서번호

COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.LOC IS '부서위치';
COMMENT ON COLUMN emp.empno IS '직원번호';
COMMENT ON COLUMN emp.ename IS '직원이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '성과급';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN('EMP','DEPT');


SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;


SELECT t.table_name,t.TABLE_TYPE,t.COMMENTS,c.COLUMN_NAME,c.COMMENTS
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name =c.table_name AND
t.table_name IN ('CUSTOMER','PRODUCT','CYCLE','DAILY');


--VIEW
--컬럼 제한
--자주 사용하는 결과물의 재활용
--쿼리 길이 단축

--VIEW는 QUERY다!
--TABLE 처럼 DBMS에 미리 작성한 객체
----> 작성하지 않고 QUERY 에서 바로 작성한 VIEW : IN-LINEVIEW --> 이름이 없기때문에 재활용이 불가하다.
--VEIW는 테이블이다(x)
--
--사용목적
--1. 보안 목적(특정 컬럼을 제외하고 나머지 결과만 개발자에게 제공)
--2. INLINE-VIEW를 VIEW로 생성하여 재활용, 쿼리 길이 단축
--
--생성방법
--[OR REPLACE]--> 미리 만들어져있으면 대체한다. DROP을 하지않아도된다.
--
--CREATE [OR REPLACE] VIEW 뷰명칭 [(column1, column2...)} AS
--SUBQUERY;

--emp 테이블에서 8개의 컬럼중 sal, comm 컬럼을 제외한 6개 컬럼을 제공하는 v_emp VIEW 생성

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--이러한 오류가 발생 insufficient privileges(불충분한 권한)
--개발자가 뷰를 생성하는거는 옳지는 않다. 시스템 관리자가 원래 하는일

--시스템 계정에서 내 계정으로 VIEW 생성권한 추가
--GRANT CREATE VIEW TO brinst;


--기존 인라인 뷰로 작성시
--SELECT *
--FROM (SELECT empno, ename, job, mgr, hiredate, deptno
--      FROM emp);
      
--VIEW 객체 활용
--SELECT *
--FROM v_emp;

--emp테이블에는 부서명이 없음 ==> dept 테이블과 조인을 빈번하게 진행
--조인된 결과를 view로 생성 해놓으면 코드를 간결하게 작성하는게 가능하다.

--VIEW : v_emp_dept
--dname(부서명), empno(직원번호), ename(직원이름), job(담당업무), hiredate(입사일자);

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT d.dname,e.empno, e.ename, e.job, e.hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT *
FROM v_emp_dept;

--인라인 뷰로 작성시
--SELECT *
--FROM (SELECT d.dname,e.empno, e.ename, e.job, e.hiredate
--      FROM emp e, dept d
--      WHERE e.deptno = d.deptno);
      
--VIEW 활용시
--SELECT *
--FROM v_emp_dept;

--SMITH 직원 삭제 후 v_emp_dept view 건수 변화를 확인
DELETE emp
WHERE ename = 'SMITH';

--VIEW는 물리적인 데이터를 갖지 않고, 논리적인 데이터의 정의 집합(SQL)이기 때문에
--VIEW에서 참조하는 데이터블의 데이터가 변경이 되면 VIEW의 조회 결과도 영향을 받는다.
--view에다 update하는 경우는 드물다.


--SEQUENCE : 시퀀스 - 중복되지 않는 정수값을 리턴해주는 오라클 객체
CREATE SEQUENCE 시퀀스_이름
[OPTION....]
명명규칙 : SEQ_테이블명;

emp 테이블에서 사용할 시퀀스 생성


CREATE SEQUENCE seq_emp;
--시퀀스 제공 함수
--NEXTVAL : 시퀀스에서 다음 값을 가져 올 때 사용
--CURRVAL : NEXTVAL를 사용하고 나서 현재 읽어 들인 값을 재확인


--시퀀스 주의점
--ROLLBACK을 하더라도 NEXTVAL를 통해 얻은 값이 원복되진 않는다.
--NEXTVAL를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.
SELECT seq_emp.NEXTVAL
FROM dual;


SELECT seq_emp.CURRVAL
FROM dual;


INSERT INTO emp_test VALUES(seq_emp.NEXTVAL,'james',99);

SELECT ROWID, emp.*
FROM emp;

SELECT *
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACOAAH';

--index와  table의 차이
--읽고서 버리냐 내가 필요한 부분만 읽느냐


--인덱스가 없을때 empno값으로 조회하는 경우
--emp 테이블에서 pk_emp 제약조건을 삭제하여 empno컬럼으로 인덱스가 존재하지 않는 환경

ALTER TABLE emp DROP CONSTRAINT pk_emp;

explain plan for 
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);


--emp 테이블의 empno컬럼으로 PK제약을 생성하고 동일한 SQL을 실행
--PK : UNIQUE + NOT NULL
--    (UNIQUE 인덱스를 생성해준다)
--==> empno 컬럼으로 unique 인덱스가 생성됨
--
--인덱스로 SQL을 실행하게 되면 인덱스가 없을 때와 어떻게 다른지 차이점을 확인

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
--필터는 읽고나서 버리는거 access는 내가 원하는 데이터로 바로접근

SELECT *
FROM emp
WHERE ename = 'SMITH';

--SELECT 조회컬럼이 테이블 접근에 미치는 영향
--SELECT * FROM emp WHERE empno = 7782
---->
--SELECT empno FROM emp WHERE empno = 7782;


EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
-- 위 실행계획은 테이블에 엑세스하는 과정이 빠져있다 왜냐하면 인덱스를  empno로 만들었기때문에 따로 액세스 할 필요가 없다.


--UNIQUE VS NON_UNIQUE 인덱스의 차이 확인
--1. PK_EMP삭제
--2. EMPNO 컬럼으로 NON-UNIQUE 인덱스 생성
--3. 실행계획 확인

ALTER TABLE emp DROP CONSTRAINT pk_emp;

--idx_u(n)_emp_01 --> emp테이블의 첫번째 (논)유니크
--CREATE (UNIQUE) idx_~~ ON 테이블명 (컬럼명) unique 붙이면 유니크인덱스 안붙이면 논유니크
CREATE INDEX idx_n_emp_01 ON emp (empno);

explain plan for
SELECT empno
FROM emp
WHERE empno = 7782;


SELECT *
FROM TABLE (dbms_xplan.display);

--|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--논 유니크는 index range scan이 등장하는데 인덱스 자체가 논유니크하기 때문에
--바로 다음인덱스를 한번 더 읽어보고, 만일 다른값이면 더 이상 검색하지 않는다.

--emp 테이블에 job 컬럼을 기준으로 하는 새로운 non-unique 인덱스를 생성

CREATE INDEX idx_n_emp_01 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

--선택가능한 사항
--1. emp 테이블을 전체 읽기
--2. idx_n_emp_01(empno) 인덱스를 활용
--3. idx_n_emp_02(job) 인덱스를 활용
--어떤게 제일 효율적일지는 오라클의 옵티마이저가 판단한다.

explain plan for
SELECT *
FROM emp
WHERE job = 'MANAGER';

select *
FROM TABLE (dbms_xplan.display);


