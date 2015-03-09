--怪物猎人 大雷光虫
function c11112011.initial_effect(c)
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11112011)
	e1:SetCondition(c11112011.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112011,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11112011+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c11112011.condition)
	e2:SetTarget(c11112011.target)
	e2:SetOperation(c11112011.operation)
	c:RegisterEffect(e2)
end
function c11112011.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b)
end
function c11112011.spfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c11112011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	    and Duel.IsExistingMatchingCard(c11112011.spfilter,tp,LOCATION_MZONE,0,2,nil)
		and not Duel.IsExistingMatchingCard(c11112011.spfilter2,tp,LOCATION_MZONE,0,1,nil)
end	
function c11112011.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c11112011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11112011.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end