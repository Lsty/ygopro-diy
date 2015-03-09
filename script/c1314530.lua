--绝冲 天险
function c1314530.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1314530+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1314530.cost)
	e1:SetTarget(c1314530.target)
	e1:SetOperation(c1314530.activate)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1314530,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetRange(0x20)
	e2:SetCondition(c1314530.condition)
	e2:SetCost(c1314530.cost2)
	e2:SetOperation(c1314530.operation)
	c:RegisterEffect(e2)
end
function c1314530.filter(c,e,tp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x9fd)
		or not c:IsCanBeSpecialSummoned(e,0x45000000,tp,true,false) then return false end
	return Duel.CheckLPCost(tp,c:GetLevel()*500) 
end
function c1314530.rfilter(c,lv)
   return c:GetLevel()==lv
end   
function c1314530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c1314530.filter,tp,0x2,0,1,nil,e,tp,lp) end  
	local g=Duel.GetMatchingGroup(c1314530.filter,tp,0x2,0,nil,e,tp)
	local t={}
	local l=1
	while g:GetCount()>0 do
	tc=g:GetMinGroup(Card.GetLevel):GetFirst()
	if tc then
		maxlv=tc:GetLevel()
		t[l]=maxlv*500
		l=l+1
		g:Remove(c1314530.rfilter,nil,maxlv)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67196946,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce/500)
end
function c1314530.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x2)
end
function c1314530.filter2(c,e,tp,lv)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x9fd)
		or not c:IsCanBeSpecialSummoned(e,0x45000000,tp,true,false) then return false end
	return c:GetLevel()==lv
end
function c1314530.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x4)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c1314530.filter2,tp,0x2,0,1,1,nil,e,tp,e:GetLabel())
	local tc=tg:GetFirst()
	if tc then
		tc:SetMaterial(Group.CreateGroup())
		Duel.SpecialSummon(tc,0x45000000,tp,tp,true,false,0x5)
		tc:CompleteProcedure()
	end
end
function c1314530.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ph~=PHASE_MAIN2 and ph~=PHASE_END
		and Duel.IsExistingMatchingCard(Card.IsAttackable,tp,0,0x4,1,nil)
end
function c1314530.tfilter(c)
	return c:IsSetCard(0x9fd) and c:IsAbleToDeckAsCost()
end  
function c1314530.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c1314530.tfilter,tp,0x20,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c1314530.tfilter,tp,0x20,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,0x80) 
end
function c1314530.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.NegateAttack()
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c1314530.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1314530.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
