--Exculibar!
function c999999984.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c999999984.sgcon)
	e1:SetCost(c999999984.sgcost)
	e1:SetTarget(c999999984.sgtg)
	e1:SetOperation(c999999984.sgop)
	c:RegisterEffect(e1)
end
function c999999984.confilter1(c)
	return c:IsFaceup() and c:IsCode(999999981) 
end
function c999999984.confilter2(c)
	return c:IsFaceup() and  c:IsSetCard(0x991)
end
function c999999984.sgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c999999984.confilter1,tp,LOCATION_SZONE,0,1,nil) and
	Duel.IsExistingMatchingCard(c999999984.confilter2,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c999999984.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0  and Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e2,tp)
end
function c999999984.filter1(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c999999984.filter2(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c999999984.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c999999984.filter1,tp,0,LOCATION_ONFIELD,1,nil) or
		Duel.IsExistingMatchingCard(c999999984.filter2,tp,0,LOCATION_ONFIELD,1,nil) 
	end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c999999984.filter1,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(999997,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c999999984.filter2,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(999997,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(999999,3))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(999997,0)
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(c999999984.filter1,tp,0,LOCATION_ONFIELD,nil)
	else sg=Duel.GetMatchingGroup(c999999984.filter2,tp,0,LOCATION_ONFIELD,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	e:SetLabel(opt)
    Duel.SetChainLimit(aux.FALSE)
end
function c999999984.sgop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(c999999984.filter1,tp,0,LOCATION_ONFIELD,nil)
	else  sg=Duel.GetMatchingGroup(c999999984.filter2,tp,0,LOCATION_ONFIELD,nil) end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end

