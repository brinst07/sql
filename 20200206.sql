SELECT sido, count(*)
FROM fastfood
WHERE sido LIKE '%대전%'
GROUP BY sido;

SELECT a.sido, a.sigungu, ROUND(a.c1/b.c2,2) hambuger_score
FROM
(SELECT sido, sigungu, count(*) c1
FROM fastfood
WHERE GB IN('KFC','버거킹','맥도날드')
GROUP BY sido, sigungu) a,

(SELECT sido, sigungu, count(*) c2
FROM fastfood
WHERE GB IN('롯데리아')
GROUP BY sido, sigungu) b

WHERE a.sido = b.sido AND
a.sigungu = b.sigungu
ORDER BY hambuger_score DESC;


--선생님이 만드신 코드
--fastfood 테이블을 한번만 읽는 방식으로 작성하기
--아래와 같은 코드를 작성할때 분모가 되는 롯데리아가 0 일경우가 생긴다 이때는 스스로 처리하는게 아니라
--상급자에게 물어보고 하는것이 좋다.


SELECT sido, sigungu, ROUND((kfc+버거킹+mac)/롯데리아,2) score
FROM
        (SELECT sido, sigungu,
            NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, NVL(SUM(DECODE(gb, '버거킹', 1)),0)버거킹,
            NVL(SUM(DECODE(gb, '맥도날드', 1)),0) mac, NVL(SUM(DECODE(gb, '롯데리아', 1)),1)롯데리아
        FROM fastfood
        WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
        GROUP BY sido, sigungu)
ORDER BY score desc;

SELECT *
FROM fastfood
WHERE sido = '경기도'
AND sigungu = '구리시';



SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;


SELECT sido, sigungu, ROUND((kfc+버거킹+mac)/롯데리아,2) score
FROM
        (SELECT sido, sigungu,
            NVL(SUM(DECODE(gb, 'KFC', 1)),0) kfc, NVL(SUM(DECODE(gb, '버거킹', 1)),0)버거킹,
            NVL(SUM(DECODE(gb, '맥도날드', 1)),0) mac, NVL(SUM(DECODE(gb, '롯데리아', 1)),1)롯데리아
        FROM fastfood
        WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
        GROUP BY sido, sigungu)
ORDER BY score desc;

-- 햄버거 지수 시도, 햄버거지수, 시군구, 햄버거지수, 세금 시도, 세금 시군구, 개인별 근로 소득액
-- ROWNUM 으로 조인을 하면 각 테이블의 1위가 동시에 출력되게 할수 있다.

--  ROWNUM 사용시 주의
--   1. SELECT --> ORDER BY
--      정렬된 결과에 ROWNUM을 적용하기 위해서는 INLINE_VIEW
--   2. 1번부터 순차적으로 조회가 되는 조건에만 WHERE절에서 기술이 가능
--      ROWNUM = 1 (O), ROWNUM = 2(X), ROWNUM < 10 (o), ROUNUM > 10 (X)

SELECT a.sido, a.sigungu, a.ham_score, b.sido, b.sigungu, b.pri_sal
FROM
(
    (SELECT ROWNUM rm1, sido,sigungu,ham_score
    FROM
        (SELECT sido, sigungu,
        ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0) + NVL(SUM(DECODE(gb, '버거킹', 1)),0)+
               NVL(SUM(DECODE(gb, '맥도날드', 1)),0) )/ NVL(SUM(DECODE(gb, '롯데리아', 1)),1),2) ham_score
        FROM fastfood
        WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
        GROUP BY sido, sigungu
        ORDER BY ham_score DESC)
        
    )a

JOIN

    (SELECT ROWNUM rm2, sido, sigungu, pri_sal
    FROM
        (SELECT sido, sigungu, ROUND(sal/people) pri_sal
        FROM tax))b
        
ON(a.rm1 = b.rm2))
ORDER BY b.pri_sal desc;    


desc dept;

--DML
--emp컬럼은 NOT NULL 제약조건이 있다. -> INSERT 시 반드시 값이 존재해야 정상적으로 입력된다.
--empno 컬럼을 제외한 나머지 컬럼은 NULLABLE이다. (NULL값이 저장될 수 있다.)
INSERT INTO emp (empno, ename, job) VALUES (9999,'brown',NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job) VALUES ('sally','SALESMAN');

--문자열 : '문자열' 
--숫자 : 10
--날짜 : TO_DATE('20200206','YYYY/MM/DD'), SYSDATE

--emp 테이블의 hiredate 컬럼은 date 타입
--emp 테이블의 8개 컬럼에 값을 입력

DESC emp;
INSERT INTO emp VALUES(9998,'sally','SALESMAN',NULL,SYSDATE,1000,NULL,99);

ROLLBACK;

--여러건의 데이터를 한번에 INSERT
--INSERT INTO 테이블명 (컬럼명1, 컬럼명2.....)
--SELECT ..
--FROM
--SELECT 결과가 테이블에 들어간다.


INSERT INTO emp
SELECT 9998,'sally','SALESMAN',NULL,SYSDATE,1000,NULL,99
FROM dual
    UNION ALL
SELECT 9999,'brown','CLERK',NULL,TO_DATE('20200205','YYYYMMDD'),1100,NULL,99
FROM dual;

SELECT *
FROM emp;

--UPDATE
--WHERE 절이 없다면 정말 위험한 상황이다 --> 모든행을 대상으로 update를 하겠다는 말임
--UPDATE 테이블명 set 컬럼명1 = 갱신할 컬럼값1, 컬럼명2= 갱신할 컬럼 값2....
--UPDATE, DELETE 절에 WHERE 절이 없으면 의도한게 맞는지 다시한번 확인한다.
--WHERE 절이 있다고 하더라도 해당조건으로 해당 테이블을 SELECT하는 쿼리를 작성하여 실행하면 UPDATE 대상 행을 조회 할 수
--있으므로 확인하고 실행하는 것도 사고 발생 방지에 도움이 된다.

--99번 부서번호를 갖는 부서 정보가 DEPT테이블에 있는 상황
INSERT INTO dept VALUES (99,'DDIT','daejeon');

--99번 부서번호를 갖는 부서의 dname 컬럼의 값을 '대덕it', loc 컬럼의 값을 '영민빌딩'으로 업데이트한다.

UPDATE dept SET dname = '대덕IT', loc= '영민빌딩'
WHERE deptno = '99';

select *
FROM dept;

ROLLBACK;

--실수로 WHERE절을 기술하지 않았을 경우
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩';


-- 10--> SUBQUERY
--SMITH, WARD가 속한 부서에 소속된 직원 정보
SELECT*
FROM emp
WHERE deptno IN (20,30);

SELECT*
FROM emp
WHERE deptno IN 
                (SELECT deptno
                 FROM emp
                 WHERE ename  IN ('SMITH','WARD'));

--UPDATE시에도 서브쿼리사용이 가능
INSERT INTO emp (empno, ename) VALUES(9999, 'brown');
--9999번 사원 deptno, job정보를 SMITH 사원이 속한 부서정보, 담당업무로 업데이트

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno=9999;

SELECT *
FROM emp;

ROLLBACK;


--DELETE SQL : 특정 행을 삭제
--DELETE [FROM] 테이블명 WHERE 행제한 조건

--99번 부서번호에 해당하는 부서 정보 삭제

DELETE dept 
WHERE deptno = '99';

SELECT *
FROM dept;
COMMIT;

--SUBQUERY를 통해서 특정 행을 제한하는 조건을 갖는 DELETE
--매니저가 7698사번인 직원을 삭제하는 쿼리를 작성

DELETE EMP
WHERE empno IN (SELECT empno FROM emp WHERE mgr = '7698') ;
rollback;

