--女仆 杀必死时间！
function c999989004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999997,8))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,999989004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c999989004.target)
	e1:SetOperation(c999989004.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999997,13))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,999989004+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989004.spcon)
	e2:SetTarget(c999989004.sptg)
	e2:SetOperation(c999989004.spop)
	c:RegisterEffect(e2)
end
function c999989004.filter(c)
	return c:IsType(TYPE_MONSTER) and  c:IsFaceup()  and (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)) 
end
function c999989004.spfilter(c,e,tp)
	return  c:IsType(TYPE_MONSTER)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and  (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb))
end
function c999989004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c999989004.filter,tp,LOCATION_MZONE,0,1,nil) and  
	 Duel.IsExistingMatchingCard(c999989004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)  and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and 
    Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999989004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-2 then return end
    local h=Duel.GetMatchingGroupCount(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,nil)
	if h>=2 then
	local g1=Duel.SelectTarget(tp,c999989004.filter,tp,LOCATION_MZONE,0,1,2,nil)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,g1:GetCount(),g1:GetCount(),nil)
	local g3=Group.CreateGroup()
    g3:Merge(g1)
	g3:Merge(g2)
	if g1:GetCount()<1 then return end
	Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
	local g4=Duel.SelectMatchingCard(tp,c999989004.spfilter,tp,LOCATION_DECK,0,g1:GetCount(),g1:GetCount(),nil,e,tp)
		Duel.SpecialSummon(g4,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangePosition(g4,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
     else
	local g1=Duel.SelectTarget(tp,c999989004.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	local g3=Group.CreateGroup()
    g3:Merge(g1)
	g3:Merge(g2)
	if g1:GetCount()~=1 then return end
	Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
	local g4=Duel.SelectMatchingCard(tp,c999989004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g4,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangePosition(g4,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
end
end
function c999989004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c999989004.spfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)) 
end
function c999989004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return   Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
    Duel.IsExistingMatchingCard(c999989004.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c999989004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local g=Duel.SelectMatchingCard(tp,c999989004.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
end