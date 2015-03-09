--传说之魔术师 玉藻前
function c999989937.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,8))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,999989937+EFFECT_COUNT_CODE_OATH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c999989937.spcost)
	e1:SetTarget(c999989937.sptg)
	e1:SetOperation(c999989937.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c999989937.tg)
	e2:SetOperation(c999989937.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c999989937.ccfilter(c)
	return c:IsCode(999989938) and not c:IsDisabled()
end
--[[function c999989937.costfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP+TYPE_CONTINUOUS)
end--]]
function c999989937.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if  Duel.IsExistingMatchingCard(c999989937.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,999989938)==0   then
    if chk==0 then return Duel.GetFlagEffect(tp,999989938)==0 end--and Duel.IsExistingMatchingCard(c999989937.costfilter,tp,LOCATION_HAND,0,1,nil)  end--
	Duel.RegisterFlagEffect(tp,999989938,RESET_PHASE+PHASE_END,0,1)
	--Duel.DiscardHand(tp,c999989937.costfilter,1,1,REASON_COST)--
	 else
	if chk==0 then return   e:GetHandler():IsReleasable() end  --and  Duel.IsExistingMatchingCard(c999989937.costfilter,tp,LOCATION_HAND,0,1,nil)   end--
   -- Duel.DiscardHand(tp,c999989937.costfilter,1,1,REASON_COST)--
	Duel.Release(e:GetHandler(),REASON_COST)
end
end
function c999989937.refilter(c,e,tp)
	return (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=999989937
end
function c999989937.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c999989937.refilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999989937.refilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c999989937.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_FIELD)
    	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e2:SetTargetRange(1,0)
	    e2:SetTarget(c999989937.splimit)
	    e2:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e2,tp)
end
end
function c999989937.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsType(TYPE_EFFECT) 
end
function c999989937.filter(c)
	local code=c:GetCode()
	return (code==999989938) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999989937.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989937.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999989937.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999989937.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end