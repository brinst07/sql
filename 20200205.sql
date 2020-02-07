--sub4
--dept 테이블에는 5건의 데이터가 존재
--emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서에 속해있다(deptno)
--부서중 직원이 속해 있지 않은 부서 정보를 조회
--서브쿼리에서 데이터의 조건이 맞는지 확인자 역할을 하는 서브쿼리 작성

SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);
--WHERE (SELECT deptno FROM emp) NOT IN deptno;
-- in 왼쪽에 있는 것은 결과 같이 하나여야 한다. 위값은 14건이 나오는 데이터이기 때문에 안된다.
-- sql문을 전체로 비교하지말고 값 하나하나를 대입시키는 방법으로 생각해볼것 ex) for문
-- 그룹바이를 사용하면 데이터를 읽고 묶는 작업이 추가되기 때문에 속도면에서는 느리다.
--중복을 제거할수 있다. DISTINCT -> 그렇게 중요하지는 않다.
SELECT DISTINCT deptno
FROM emp;


SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM product p
WHERE p.pid NOT IN(SELECT c.pid
                        FROM cycle c
                        WHERE c.cid =1);
                        
--sub6
SELECT pid
FROM cycle
WHERE cid = 1;

select *
FROM product
WHERE pid = 1 AND pid in (SELECT pid
                          FROM cycle
                          WHERE cid = 2);
                          
select *
from cycle;

select *
from product;

SELECT *
FROM cycle c
WHERE c.cid =1 AND c.pid in(SELECT pid
                            FROM cycle
                            WHERE cid=2);
                            

--sub6                            
SELECT *
FROM cycle c , customer cu, product p
WHERE c.cid=1 AND c.pid in(SELECT pid
                            FROM cycle
                            WHERE cid=2)
AND c.pid =p.pid AND c.cid = cu.cid;

--스칼라 서브쿼리도 가능하다 조인을 하지 않고... -> 좋은 방법이 아니다.
SELECT cycle.cid, (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);
            
--매니저가 존재하는 직원을 조회(king을 제외한 13명의 데이터가 조회
SELECT ename
FROM emp
WHERE mgr is not null;
    
--EXSITS 조건에 만족하는 행이 존재하는지 안하는지 확인하는 연산자
--다른 연산자와 다르게 WHERE절에 컬럼을 기술하지 않는다.
-- WHERE empno = 7369
-- WHERE EXISTS (SELECT 'X'
--               FROM ....);
-- 값이 중요한게 아니라 존재하는지 여부가 중요하기 때문에 'x' 를 사용 -> 약속임

--매니저가 존재하는 직원을 EIXSTS 연산자를 통해 조회

SELECT e.empno, e.ename, e.mgr
FROM emp e
WHERE EXISTS (SELECT 'x'
              FROM emp m
              WHERE e.mgr=m.empno);
              
--sub9
SELECT pid, pnm
FROM product p
WHERE EXISTS (SELECT 'x'
              FROM cycle c
              WHERE cid=1 and p.pid=c.pid);

--sub10
--왜 !가 안되는지 다시한번 생각하기
SELECT pid, pnm
FROM product p
WHERE NOT EXISTS (SELECT 'x'
              FROM cycle c
              WHERE cid = 1 and p.pid=c.pid);
              
--집합연산
--합집합 : UNION - 중복제거(집합개념) / UNION ALL - 중복을 제거하지 않음(속도향상)
--교집합 : INTERSECT(집합개념)
--차집합 : MINUS (집합개념)
--집합연산 공통사항
--두 집합의 컬럼의 개수, 타입이 일치해야한다.

-- UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--UNION ALL 연산자는 UNION 연산자와 다르게 중복을 허용한다.

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);


--INTERECT (교집합) : 위, 아래 집합에서 값이 같은 행만 조회


SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698,7369);

--MINUS(차집합) : 위 집합에서 아래 집합의 데이터를 제거한 나머지 집합


SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

--집합의 기술 순서가 영향이 가는 집합연산자
-- A UNION B =    B UNION A -> 같음
-- A UNION ALL B  B UNION ALL A -> (집합개념에서)같음
-- A INTERSECT B  B INTERSECT A -> 같음
-- A MINUS B      B MINUS A -> 다름

--집합연산의 결과 컬럼 이름은 처음 만들어진 양식을 그대로 가져감
SELECT 'X'as first,'B' as sec
FROM dual

UNION

SELECT 'Y','A',
FROM dual;

--정렬(order by)는 집합연산 가장 마지막 집합 다음에 기술
SELECT deptno, dname, loc
FROM(SELECT deptno, dname, loc
     FROM dept 
     WHERE deptno IN  (10,20)
     ORDER BY DEPTNO) --> 인라인뷰안에서  ORDERBY를 기술하면 가능하다.
--ORDER BY DEPTNO --> 오류발생

UNION

SELECT *
FROM dept 
WHERE deptno IN (30,40)
ORDER BY deptno;

SELECT *
FROM fastfood;

--시도, 시군구, 버거지수
SELECT up.sido,up.sigungu,ROUND(bmk/b,2) c , dense_rank() over(order by ROUND(bmk/b,2) desc) rank
FROM(
     SELECT  sido, sigungu,sum(a) bmk
     FROM
     
        (SELECT sido, sigungu,gb,count(gb) a
         FROM fastfood
         WHERE gb IN ('버거킹','맥도날드','KFC')
         GROUP BY sido, sigungu,gb) 
         
     GROUP BY sido, sigungu) up 
     
    JOIN
    
    (SELECT sido, sigungu,gb,count(gb) b
     FROM fastfood
     WHERE gb IN ('롯데리아')
     GROUP BY sido, sigungu,gb )down
     
    ON(up.sido=down.sido and up.sigungu = down.sigungu)
ORDER BY c DESC;
