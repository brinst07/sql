--상향식 계층 쿼리 (leaf ==> root node(상위 node))
--전체 노드를 방문하는게 아니라 자신의 부모 노드만 방문(하향식과 다른점)
--시작점 : 디자인팀
--연결은 : 상위부서

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;

--ORACLE 계층 쿼리의 탐색 순서는 pre-order이다.

h_4;
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

select *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*4) ||S_ID s_id, VALUE
FROM h_sum
START WITH s_id='0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT *
FROM no_emp;

--h_5
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;

--계층형 쿼리의 행 제한 조건 기술 위치에 따른 결과 비교(pruning branch - 가지치기)
--FROM -> START WITH, CONNECT BY -> WHERE
--1. WHERE : 계층 연결을 하고 나서 행을 제한
--2. CONNECT BY : 계층 연결을 하는 과정에서 행을 제한

--WHERE 절 기술전 : 총 9개의 행이 조회되는것 확인
--WHERE 절 (deptnm != 정보기획부) : 정보기획부를 제외한 8개의 행 조회되는 것 확인(정보기획부 하위의 팀이나 파트는 출력)

SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;

--CONNECT BY 절에 조건을 기술
--연결하는 과정에서 아예 차단이 되어버린다.
--정보기획부의 하위의 부서나 팀까지 출력이 안되어버린다.
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd AND org_cd != '정보기획부';

--CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 최상위 행의 값을
--ex) 게시글을 올리고 그 아래에 답글을 달때 게시글을 최상위로 주고 답글을 그 아래 레벨로 사용해서 활용한다.
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp,
       CONNECT_BY_ROOT(org_cd) root
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;

--SYS_CONNECT_BY_PATH(컬럼, 구분자) : 해당 행이 컬럼을 거쳐온 컬럼 값을 추천, 구분자로 이어준다.
--이 함수는 맨 좌측이 -가 무조건 붙기 때문에 LTRIM 과 한쌍처럼 사용된다.
SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD or_cd, no_emp,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-')PATH
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;


--CONNECT_BY_ISLEAF : 해당 행이 LEAF 노드인지(연결된 자식이 없는지)값을 리턴 [1.leaf, 0. no leaf]

SELECT LPAD(' ',(LEVEL-1)*5) || ORG_CD org_cd, no_emp,
       CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;

--h6
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

select *
FROM board_test;


SELECT SEQ, LPAD(' ', (LEVEL-1)*4 ) || title title
FROM board_test
START WITH seq IN (1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;

--다시 풀어볼 문제
--시작하는 루트가 여러개이기 때문에 start with절에 잘 기술을 해줘야한다.
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) gn
FROM board_test
START WITH parent_seq is null
CONNECT BY prior seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc; 

--그룹번호를 저장할 컬럼을 추가
ALTER TABLE board_test ADD(gn NUMBER);
update board_test SET gn = 4
WHERE seq IN(4,5,6,7,8,10,11);

update board_test SET gn = 2
WHERE seq IN(2,3);

update board_test SET gn = 1
WHERE seq IN(1,9);

commit;

-- level이나 sys함수 등을 order by siblings에서 바로 사용이 불가능하다. 사용하려면 서브쿼리로 묶어야 하는데
-- 이렇게 묶으버리면 계층구조가 깨지게 된다.
-- 따라서 디코드나 케이스문으로 따로 그룹번호 처럼 만들어서 order siblings by 로 그룹번호로 정렬, seq로 정렬시켜야한다.
SELECT seq, lpad(' ', (LEVEL-1)*4) || title title,  DECODE(parent_seq, NULL, seq, parent_seq) gn
FROM board_test
START WITH parent_seq IS nULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc;

SELECT seq, lpad(' ', (LEVEL-1)*4) || title title,
        DECODE(parent_seq, NULL, seq, parent_seq) code
FROM board_test
START WITH parent_seq IS nULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq asc;

SELECT *
FROM BOARD_TEST;

STAR

FROM emp
ORDER BY deptno desc, empno asc;

SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp);

SELECT ename, sal, deptno, ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal desc) sal_rank
FROM emp
GROUP BY ename, sal, deptno
ORDER BY deptno, sal desc;

SELECT ename, sal, deptno, rownum
FROM
(SELECT ename, sal, deptno, rownum
FROM emp
WHERE deptno =10
ORDER BY sal desc,rownum)


UNION

SELECT ename, sal, deptno, rownum
FROM
(SELECT ename, sal, deptno, rownum
FROM emp
WHERE deptno =20
ORDER BY sal desc,rownum)


UNION 

SELECT ename, sal, deptno, rownum
FROM
(SELECT ename, sal, deptno, rownum
FROM emp
WHERE deptno =30
ORDER BY sal desc,rownum)
ORDER BY  deptno, sal desc;


SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= 14) a,

(SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv;

SELECT deptno, LEVEL
FROM emp
START WITH e
CONNECT BY LEVEL=1;

SELECT *
FROM
(SELECT emp.*,ROWNUM
FROM emp) a,

(SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv;
