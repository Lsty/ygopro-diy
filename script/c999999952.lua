--传说之剑士 尼禄·克劳迪乌斯
function c999999952.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
   --copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999998,13))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c999999952.cost)
	e1:SetTarget(c999999952.target)
	e1:SetOperation(c999999952.operation)
	c:RegisterEffect(e1)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(68811206,0))
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetCondition(c999999952.damcon)
	e8:SetTarget(c999999952.damtg)
	e8:SetOperation(c999999952.damop)
	c:RegisterEffect(e8)
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999998,14))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c999999952.cost)
	e2:SetTarget(c999999952.target2)
	e2:SetOperation(c999999952.activate)
	c:RegisterEffect(e2)--]]
    --search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c999999952.scon)
	e3:SetTarget(c999999952.stg)
	e3:SetOperation(c999999952.sop)
	c:RegisterEffect(e3)
--[[	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c999999952.econ)
	e4:SetValue(c999999952.elimit)
	c:RegisterEffect(e4)
	c999999952[1]=0
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c999999952.aclimit8)
	c:RegisterEffect(e7)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c999999952.aclimit9)
	c:RegisterEffect(e2)--]]
end
function c999999952.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(999999952)==0 and Duel.CheckLPCost(tp,1000) end
	e:GetHandler():RegisterFlagEffect(999999952,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,1000)
end
function c999999952.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:GetCode()~=999999952
end
function c999999952.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(0x14) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c999999952.cfilter,tp,0x14,0x14,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999999952.cfilter,tp,0x14,0x14,1,1,e:GetHandler())
end
function c999999952.operation(e,tp,eg,ep,ev,re,r,rp)
  --  c999999952[1]=c999999952[1]+1
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
	    local code=tc:GetOriginalCode()
		if not tc:IsType(TYPE_TOKEN+TYPE_TRAPMONSTER) then
			c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END, 2)
			--c:RegisterFlagEffect(999999952,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
--[[function c999999952.cffilter(c,ty)
	return c:IsLocation(LOCATION_HAND) and  c:IsType(ty) and c:IsAbleToGrave()
end
function c999999952.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local ac=Duel.SelectOption(tp,71,72,70)
	local ty=TYPE_SPELL
	if ac==1 then ty=TYPE_TRAP end
	if ac==2 then ty=TYPE_MONSTER end
	e:SetLabel(ty)
end
function c999999952.activate(e,tp,eg,ep,ev,re,r,rp)
   c999999952[1]=c999999952[1]+1
    local c=e:GetHandler()
	local ty=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local cg=g:Filter(c999999952.cffilter,nil,ty)
		if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(cg,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,999999952,RESET_PHASE+PHASE_END,0,1)
	 Duel.ShuffleHand(tp)
	 else
	 Duel.ConfirmCards(1-tp,g)
	  Duel.ShuffleHand(tp)
	 end
        	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if Duel.GetFlagEffect(tp,999999952)~=0 then
	if e:GetLabel()==1 then
		e1:SetValue(c999999952.aclimit1)
	elseif e:GetLabel()==2 then
		e1:SetValue(c999999952.aclimit2)
	else e1:SetValue(c999999952.aclimit3) end
	e1:SetReset(RESET_PHASE+PHASE_END,cg:GetCount()*2)
	Duel.RegisterEffect(e1,tp)
end
end
function c999999952.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c999999952.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c999999952.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end--]]
function c999999952.scon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c999999952.sfilter(c)
	return c:IsCode(999989950) 
end
function c999999952.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return   chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and c999999952.sfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c999999952.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c999999952.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK+LOCATION_GRAVE) 
end
function c999999952.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if g then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	--c999999952[1]=c999999952[1]
	end
end
--[[function c999999952.aclimit8(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:IsActiveType(TYPE_SPELL) then return end
	e:GetHandler():RegisterFlagEffect(a,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c999999952.aclimit9(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:IsActiveType(TYPE_SPELL) then return end
	e:GetHandler():ResetFlagEffect(a)
end
function c999999952.econ(e)
	return e:GetHandler():GetFlagEffect(a)~=0  and c999999952[1]~=0
end
function c999999952.elimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end--]]
function c999999952.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function c999999952.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c999999952.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
