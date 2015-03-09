--怪物猎人 狗龙
function c11112036.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11112036)
	e1:SetCondition(c11112036.spcon)
	e1:SetTarget(c11112036.sptg)
	e1:SetOperation(c11112036.spop)
	c:RegisterEffect(e1)
	--self special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112036,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11112036)
	e2:SetCondition(c11112036.condition)
	e2:SetTarget(c11112036.target)
	e2:SetOperation(c11112036.operation)
	c:RegisterEffect(e2)
end	
function c11112036.cfilter(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(3) and c:IsSetCard(0x15b) and c:GetSummonPlayer()==tp
end
function c11112036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11112036.cfilter,1,nil,tp)
end
function c11112036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11112036.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    Duel.DiscardDeck(tp,1,REASON_EFFECT)
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		    e1:SetValue(1)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
	        c:RegisterEffect(e1,true)
		    local e2=Effect.CreateEffect(c)
		    e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e2:SetReset(RESET_EVENT+0x47e0000)
		    e2:SetValue(LOCATION_REMOVED)
		    c:RegisterEffect(e2,true)
			Duel.BreakEffect()
		    Duel.Draw(tp,1,REASON_EFFECT)
		end	
	end
end
function c11112036.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c11112036.spfilter(c,e,tp)
	return c:IsSetCard(0x15b) and c:IsLevelBelow(2) and not c:IsCode(11112036) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11112036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11112036.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11112036.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11112036.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end