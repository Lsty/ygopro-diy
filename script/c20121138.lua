--Black★World
function c20121138.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c20121138.tg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--defup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c20121138.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20121138,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c20121138.target2)
	e4:SetOperation(c20121138.activate2)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20121138,1))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c20121138.target1)
	e5:SetOperation(c20121138.activate1)
	c:RegisterEffect(e5)
end
function c20121138.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function c20121138.filter2(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x777) and c:IsType(TYPE_MONSTER)
end
function c20121138.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c20121138.filter2(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(20121138)==0 and Duel.IsExistingTarget(c20121138.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(20121138,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c20121138.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c20121138.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c20121138.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x777) and c:IsType(TYPE_MONSTER)
end
function c20121138.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c20121138.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(20121138)==0 and Duel.IsExistingTarget(c20121138.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(20121138,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20121138,2))
	local g=Duel.SelectTarget(tp,c20121138.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c20121138.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end