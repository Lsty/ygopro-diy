--神天龙-云龙
function c9991215.initial_effect(c)
	--Fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),true)
	--DD Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991215,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991215)
	e1:SetCondition(c9991215.spcon)
	e1:SetTarget(c9991215.sptg)
	e1:SetOperation(c9991215.spop)
	c:RegisterEffect(e1)
	--To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991215,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9991215)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9991215.ccost)
	e2:SetTarget(c9991215.ctg)
	e2:SetOperation(c9991215.cop)
	c:RegisterEffect(e2)
	--Summon Limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c9991215.sumsuc)
	c:RegisterEffect(e3)
end
function c9991215.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9991215.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetSummonPlayer()==tp
end
function c9991215.spfilter(c,e,tp)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991215.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991215.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and eg:IsExists(c9991215.cfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9991215.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991215.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP)
	end
end
function c9991215.cfilter2(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991215.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991215.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991215.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9991215.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end
function c9991215.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c9991215.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991215.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991215.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsSetCard(0xfff) and bit.band(c:GetOriginalType(),TYPE_FUSION)>0
end
