--宝具 祈祷之弓
function c999989947.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999989947.target)
	e1:SetOperation(c999989947.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999989947.eqlimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999989947,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c999989947.descon)
	e4:SetTarget(c999989947.destg)
	e4:SetOperation(c999989947.desop)
	c:RegisterEffect(e4)
	end
function c999989947.eqlimit(e,c)
	return  c:IsCode(999999954) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999989947.filter(c)
	return c:IsFaceup() and c:IsCode(999999954) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999989947.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c999989947.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989947.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c999989947.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999989947.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999989947.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local dt=nil
	if ec==Duel.GetAttacker() then dt=Duel.GetAttackTarget()
	elseif ec==Duel.GetAttackTarget() then dt=Duel.GetAttacker() end
	e:SetLabelObject(dt)
	return dt and dt:IsRelateToBattle()
end
function c999989947.destg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c999989947.desop(e,tp,eg,ep,ev,re,r,rp)
	local dt=e:GetLabelObject()
	if dt:IsRelateToBattle() then
		Duel.Destroy(dt,REASON_EFFECT)
	end
end
