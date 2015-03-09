--无双猎人 雷狼龙
function c11112029.initial_effect(c)
    c:EnableCounterPermit(0xfb)
	c:SetCounterLimit(0xfb,10)
    --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x15b),1)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c11112029.matcheck)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112029,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11112029.addcon)
	e2:SetOperation(c11112029.addc)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--add counter2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11112029,1))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c11112029.ctcon)
	e3:SetCost(c11112029.ctcost)
	e3:SetTarget(c11112029.cttg)
	e3:SetOperation(c11112029.ctop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c11112029.desreptg)
	e4:SetOperation(c11112029.desrepop)
	c:RegisterEffect(e4)
	--attackup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetCondition(c11112029.effcon)
	e6:SetLabel(6)
	e6:SetValue(500)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetCondition(c11112029.effcon)
	e7:SetValue(c11112029.tgvalue)
	e7:SetLabel(8)
	c:RegisterEffect(e7)
	--send to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(11112029,3))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c11112029.effcon)
	e8:SetCost(c11112029.descost)
	e8:SetTarget(c11112029.destg)
	e8:SetOperation(c11112029.desop)
	e8:SetLabel(10)
	c:RegisterEffect(e8)
end
function c11112029.matcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x15b)
	e:SetLabel(ct)
end	
function c11112029.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11112029.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xfb,e:GetLabelObject():GetLabel())
	end
end
function c11112029.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xfb)<=9
end
function c11112029.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11112029.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112029.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsSetCard,nil,0x15b)
		if ct>0 then
		    if e:GetHandler():GetCounter(0xfb)==9 then
		        e:GetHandler():AddCounter(0xfb,1)
			else
                e:GetHandler():AddCounter(0xfb,ct)		
			end	
		end
	end
end
function c11112029.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0xfb)>1 end
	return Duel.SelectYesNo(tp,aux.Stringid(11112029,2))
end
function c11112029.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xfb,2,REASON_EFFECT)
end
function c11112029.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xfb)>=e:GetLabel()
end
function c11112029.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c11112029.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and e:GetHandler():GetCounter(0xfb)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local ct=e:GetHandler():GetCounter(0xfb)
	e:GetHandler():RemoveCounter(tp,0xfb,ct,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c11112029.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c11112029.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end