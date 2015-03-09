--宝具 妄想心音
function c999989943.initial_effect(c)
	c:SetUniqueOnField(1,0,999989943)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999989943.target)
	e1:SetOperation(c999989943.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999989943.eqlimit)
	c:RegisterEffect(e2)
	--[[search card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999999,7))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c999989943.secost)
	e3:SetTarget(c999989943.setarget)
	e3:SetOperation(c999989943.seoperation)
	c:RegisterEffect(e3)--]]
	--coin
	local e4=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COIN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c999989943.cotg)
	e4:SetOperation(c999989943.coop)
	c:RegisterEffect(e4)

end
function c999989943.eqlimit(e,c)
	return  c:IsCode(999999994)  
end
function c999989943.filter(c)
	return c:IsFaceup() and c:IsCode(999999994) 
end
function c999989943.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999989943.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989943.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999989943.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999989943.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--[[function c999989943.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,999989943)==0  and Duel.GetFlagEffect(tp,999999994)==0  end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,999989943,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,999999994,RESET_PHASE+PHASE_END,0,1)
end
function c999989943.sefilter(c)
	return c:GetCode()==999999994 and c:IsAbleToHand()
end
function c999989943.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989943.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999989943.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c999989943.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end--]]
function c999989943.cotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
    Duel.IsPlayerCanSpecialSummonMonster(tp,999999965,0x4011,0x4011,1500,1200,3,RACE_WARRIOR,ATTRIBUTE_DARK)  end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,1-tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c999989943.coop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_COIN)
	local b=0
	local d={}
	local t={}
	for i=1, 3 do
    t[i]=Duel.AnnounceCoin(1-tp) 
   d[i] = Duel.TossCoin(1-tp,1)
	if d[i]~=t[i] then
	 b=b+1
	 end
 end 
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then  return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,999999965,0x4011,0x4011,1500,1200,3,RACE_WARRIOR,ATTRIBUTE_DARK) then
			local token=Duel.CreateToken(tp,999999965)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
		          e1:SetOwnerPlayer(tp)
		          e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		          e1:SetRange(LOCATION_MZONE)
		          e1:SetCode(EVENT_PHASE+PHASE_END)
		          e1:SetOperation(c999989943.desop)
		          e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		          e1:SetCountLimit(1)
			      token:RegisterEffect(e1,true)
		          local e2=Effect.CreateEffect(e:GetHandler())
			      e2:SetType(EFFECT_TYPE_SINGLE)
			      e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			      e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			      e2:SetValue(1)
			      e2:SetReset(RESET_EVENT+0x1fe0000)
			      token:RegisterEffect(e2,true)
			      if b==0 then
		       	  local e3=Effect.CreateEffect(e:GetHandler())
	              e3:SetType(EFFECT_TYPE_SINGLE)
	              e3:SetCode(EFFECT_IMMUNE_EFFECT)
	              e3:SetValue(c999989943.efilter)
	              token:RegisterEffect(e3,true)
			      local e4=Effect.CreateEffect(e:GetHandler())
	              e4:SetCategory(CATEGORY_TOGRAVE)
	              e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	              e4:SetCode(EVENT_BATTLE_END)
	              e4:SetRange(LOCATION_MZONE)
	              e4:SetCondition(c999989943.sgcon)
	              e4:SetTarget(c999989943.sgtg)
	              e4:SetOperation(c999989943.sgop)
	              token:RegisterEffect(e4,true)
				  elseif b==1 then
			      local e5=Effect.CreateEffect(e:GetHandler())
	              e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	              e5:SetRange(LOCATION_MZONE)
	              e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	              e5:SetTargetRange(0,1)
				  e5:SetOperation(c999989943.acop)
	              e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
	              token:RegisterEffect(e5,true)
		          elseif b==2 then
		          local e6=Effect.CreateEffect(e:GetHandler())
	              e6:SetType(EFFECT_TYPE_SINGLE)
	              e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	              token:RegisterEffect(e6,true)
			      else 
			      local e7=Effect.CreateEffect(e:GetHandler())
		          e7:SetType(EFFECT_TYPE_SINGLE)
		          e7:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		          e7:SetReset(RESET_EVENT+0x1fe0000)
	              token:RegisterEffect(e7,true)
		end
	Duel.SpecialSummonComplete()
end
end
function c999989943.desop(e,tp,eg,ep,ev,re,r,rp) 
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end	
function c999989943.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c999989943.sgcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	return Duel.GetAttackTarget()==ec or (Duel.GetAttacker()==ec and Duel.GetAttackTarget())
end
function c999989943.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c999989943.sgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end
function c999989943.acop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c999989943.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c999989943.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end
