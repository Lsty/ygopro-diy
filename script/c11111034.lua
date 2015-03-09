--君主VIII 喜悦的格兰德
function c11111034.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
    --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111034,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c11111034.cost)
	e1:SetOperation(c11111034.operation)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11111034.atkcon)
	e2:SetOperation(c11111034.atkup)
	c:RegisterEffect(e2)
end
function c11111034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11111034.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	   e1:SetCountLimit(1)
	   e1:SetValue(c11111034.valcon)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	   c:RegisterEffect(e1)
	   --damage conversion
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e2:SetCode(EFFECT_REVERSE_DAMAGE)
	   e2:SetTargetRange(1,0)
	   e2:SetValue(1)
	   e2:SetReset(RESET_PHASE+RESET_END)
	   Duel.RegisterEffect(e2,tp)
	end
end
function c11111034.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		e:GetHandler():RegisterFlagEffect(11111034,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
		return true
	else return false end
end	
function c11111034.atkcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c11111034.atkup(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or not d==e:GetHandler() or d:IsControler(1-tp) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
	e1:SetValue(-1000)
	a:RegisterEffect(e1)
end