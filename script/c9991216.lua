--神天龙-冥龙
function c9991216.initial_effect(c)
	--Fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),true)
	--DD Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991216,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991216)
	e1:SetCondition(c9991216.spcon)
	e1:SetTarget(c9991216.sptg)
	e1:SetOperation(c9991216.spop)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991216,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9991216)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9991216.ccost)
	e2:SetTarget(c9991216.ctg)
	e2:SetOperation(c9991216.cop)
	c:RegisterEffect(e2)
	--Summon Limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c9991216.sumsuc)
	c:RegisterEffect(e3)
end
function c9991216.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9991216.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetSummonPlayer()==tp
end
function c9991216.spfilter(c,e,tp)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991216.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991216.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and eg:IsExists(c9991216.cfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9991216.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991216.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP)
	end
end
function c9991216.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,2) end
	Duel.DiscardDeck(tp,2,REASON_COST)
end
function c9991216.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function c9991216.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c9991216.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991216.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991216.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsSetCard(0xfff) and bit.band(c:GetOriginalType(),TYPE_FUSION)>0
end
