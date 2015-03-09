--神天龙-尘龙
function c9991211.initial_effect(c)
	--Fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),true)
	--DD Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991211,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991211)
	e1:SetCondition(c9991211.spcon)
	e1:SetTarget(c9991211.sptg)
	e1:SetOperation(c9991211.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991211,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9991211)
	e2:SetCondition(c9991211.discon)
	e2:SetTarget(c9991211.distg)
	e2:SetOperation(c9991211.disop)
	c:RegisterEffect(e2)
	--Summon Limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c9991211.sumsuc)
	c:RegisterEffect(e3)
end
function c9991211.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9991211.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetSummonPlayer()==tp
end
function c9991211.spfilter(c,e,tp)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991211.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991211.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and eg:IsExists(c9991211.cfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991211.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991211.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP)
	end
end
function c9991211.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ( loc==LOCATION_MZONE or loc==LOCATION_SZONE ) and ep~=tp
end
function c9991211.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991211.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9991211.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991211.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991211.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsSetCard(0xfff) and bit.band(c:GetOriginalType(),TYPE_FUSION)>0
end
