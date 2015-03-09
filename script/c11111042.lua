--银星之贤者 卡林
function c11111042.initial_effect(c)
	--special summon
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11111042)
	e1:SetCost(c11111042.spcost)
	e1:SetTarget(c11111042.sptg)
	e1:SetOperation(c11111042.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111042,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c11111042.setcon)
	e2:SetTarget(c11111042.settg)
	e2:SetOperation(c11111042.setop)
	c:RegisterEffect(e2)
end
function c11111042.cffilter(c)
	return c:IsLevelAbove(6) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_SPELLCASTER))  
	       and not c:IsCode(11111042) and not c:IsPublic() 
end
function c11111042.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111042.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11111042.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c11111042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11111042.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENCE)~=0 then
	    --cannot release
	    local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	    e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
     	local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e2,true)
	    local e3=Effect.CreateEffect(e:GetHandler())
	    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    e3:SetRange(LOCATION_MZONE)
	    e3:SetCode(EVENT_PHASE+PHASE_END)
	    e3:SetOperation(c11111042.rmop)
	    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	    e3:SetCountLimit(1)
	    c:RegisterEffect(e3,true)
	end
end
function c11111042.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c11111042.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c11111042.setfilter(c)
	return c:IsType(TYPE_QUICKPLAY+TYPE_EQUIP) and c:IsSSetable()
end
function c11111042.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11111042.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11111042.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11111042.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end