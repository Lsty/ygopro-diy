--最终武装的魔王少女
function c187187003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3abb),5,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10187,2))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c187187003.eqcon)
	e1:SetTarget(c187187003.eqtg)
	e1:SetOperation(c187187003.eqop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10187,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c187187003.rmcost)
	e2:SetTarget(c187187003.rmtg)
	e2:SetOperation(c187187003.rmop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c187187003.cona)
	e3:SetValue(c187187003.val)
	c:RegisterEffect(e3)
	--def
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
end
function c187187003.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb) 
end
function c187187003.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x6abb)
end
function c187187003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c187187003.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c187187003.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectOption(tp,aux.Stringid(10187,13))
	Duel.SelectOption(1-tp,aux.Stringid(10187,13))
	Duel.Hint(HINT_CARD,0,187187025)
	Duel.Hint(HINT_CARD,0,187187029)
	Duel.Hint(HINT_CARD,0,187187023)
	Duel.Hint(HINT_CARD,0,187187027)
	Duel.Hint(HINT_CARD,0,187187024)
	Duel.Hint(HINT_CARD,0,187187011)
	Duel.Hint(HINT_CARD,0,187187007)
	Duel.Hint(HINT_CARD,0,187187010)
	Duel.Hint(HINT_CARD,0,187187015)
	Duel.Hint(HINT_CARD,0,187187025)
	Duel.Hint(HINT_CARD,0,187187005)
	Duel.Hint(HINT_CARD,0,187187014)
	Duel.Hint(HINT_CARD,0,187187002)
    Duel.SelectOption(tp,aux.Stringid(10187,2))
	Duel.SelectOption(1-tp,aux.Stringid(10187,2))
	Duel.Hint(HINT_CARD,0,187187003)	
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c187187003.filter,tp,LOCATION_GRAVE,0,1,fc,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c187187003.eqlimit(e,c)
	return e:GetOwner()==c
end
function c187187003.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false,true)
		tc:RegisterFlagEffect(187187003,RESET_EVENT+0x1fe0000,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c187187003.eqlimit)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end
function c187187003.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c187187003.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c187187003.rmfilter(c)
	return c:IsAbleToRemove()
end
function c187187003.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187187003.rmfilter,tp,0,LOCATION_MZONE+LOCATION_SZONE,1,nil) end
	Duel.SelectOption(tp,aux.Stringid(10187,3))
	Duel.SelectOption(1-tp,aux.Stringid(10187,3))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE+LOCATION_SZONE)
end
function c187187003.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c187187003.rmfilter,tp,0,LOCATION_MZONE+LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c187187003.cona(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE+LOCATION_SZONE)
end
function c187187003.val(e,c)
	return c:GetEquipCount()*500
end

