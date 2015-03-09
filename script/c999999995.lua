--传说之魔术师 美狄亚
function c999999995.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,8))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c999999995.spcost)
	e1:SetTarget(c999999995.sptg)
	e1:SetOperation(c999999995.spop)
	c:RegisterEffect(e1)
		c999999995.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetRange(LOCATION_MZONE)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c999999995.checkop)
		c:RegisterEffect(ge1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,999999995+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c999999995.tg)
	e2:SetOperation(c999999995.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetCondition(c999999995.ccon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    --send to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c999999995.sgop)
	c:RegisterEffect(e5)
	e1:SetLabelObject(e5)

end
--[[function c999999995.ccfilter(c)
	return c:IsCode(999989938) and not c:IsDisabled()
end--]]
function c999999995.costfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP+TYPE_CONTINUOUS)
end
function c999999995.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[if  Duel.IsExistingMatchingCard(c999999995.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,999989938)==0 then
    if chk==0 then return Duel.GetFlagEffect(tp,999989938)==0  end
	Duel.RegisterFlagEffect(tp,999989938,RESET_PHASE+PHASE_END,0,1)
	 else--]]
	if chk==0 then return  Duel.IsExistingMatchingCard(c999999995.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c999999995.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c999999995.spfilter(c,e,tp)
	return (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=999999995
end
function c999999995.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999999995.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999999995.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999999995.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,1,tp,tp,false,false,POS_FACEUP)
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_FIELD)
    	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e2:SetTargetRange(1,0)
	    e2:SetTarget(c999999995.splimit)
	    e2:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e2,tp)
    if c:IsFaceup() and c:IsRelateToEffect(e) then 
	c:SetCardTarget(tc)
	e:GetLabelObject():SetLabelObject(tc)
			c:CreateRelation(tc,RESET_EVENT+0x5020000)
			tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
end
end
end
function c999999995.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO))
end
function c999999995.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	e:SetLabelObject(eg:GetFirst())
	if eg:GetFirst()==tc then return end
	if  eg:GetFirst():GetSummonType()==SUMMON_TYPE_SPECIAL+1 then 
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_DECK,0)
	e1:SetTarget(c999999995.val)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,e:GetHandlerPlayer())
end
end
function c999999995.val(e,c)
  return   c:IsType(TYPE_EQUIP) 
end
function c999999995.filter(c)
	local code=c:GetCode()
	return (code==999999976) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999999995.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999995.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999995.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999995.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999999995.sgfilter(c,rc)
	return rc:GetCardTarget():IsContains(c) 
end
function c999999995.ccon(e)
	return   e:GetHandler():GetCardTarget():IsExists(c999999995.sgfilter,1,nil,e:GetHandler()) 
end
function c999999995.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToCard(tc) and tc:IsRelateToCard(c) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
end
end