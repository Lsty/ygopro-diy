--幻想镜现诗·蠢动的秋月
function c19300094.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19300094+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c19300094.cost)
	e1:SetTarget(c19300094.target)
	e1:SetOperation(c19300094.activate)
	c:RegisterEffect(e1)
	if not c19300094.global_check then
		c19300094.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c19300094.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c19300094.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c19300094.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLevelAbove(6) then
			c19300094[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c19300094.clear(e,tp,eg,ep,ev,re,r,rp)
	c19300094[0]=true
	c19300094[1]=true
end
function c19300094.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c19300094[tp] and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c19300094.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19300094.splimit(e,c)
	return c:IsLevelAbove(6)
end
function c19300094.spfilter(c,e,tp)
	return c:IsSetCard(0x193) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19300094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c19300094.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:GetClassCount(Card.GetLevel)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c19300094.rfilter(c,lv)
	return c:GetLevel()==lv
end
function c19300094.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(c19300094.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(c19300094.rfilter,nil,sg1:GetFirst():GetLevel())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		local tc=sg1:GetFirst()
		while tc do
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=sg1:GetNext()
		end
	end
end