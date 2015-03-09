--君主XIII 肉体的尼库塔
function c11111021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,3)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111021,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11111021.spcost)
	e1:SetTarget(c11111021.sptg)
	e1:SetOperation(c11111021.spop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111021,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCondition(c11111021.tdcon)
	e2:SetTarget(c11111021.tdtg)
	e2:SetOperation(c11111021.tdop)
	c:RegisterEffect(e2)
end
function c11111021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) and Duel.GetFlagEffect(tp,11111021)==0 end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,11111021,RESET_PHASE+PHASE_END,0,1)
end
function c11111021.filter(c,e,tp)
	return c:IsRankBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c11111021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111021.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11111021.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11111021.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	    local tc=g:GetFirst()
	    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local og=e:GetHandler():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	    tc:RegisterEffect(e1)
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if cg and cg:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cg)
		end
	end
end
function c11111021.cfilter(c,e)
	return c:GetLevel()==2 and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function c11111021.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c11111021.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c11111021.cfilter(chkc,e) end
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c11111021.cfilter,tp,LOCATION_GRAVE,0,nil,e)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,3,3,nil)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,3,0,0)
	end
end
function c11111021.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=3 then return end
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
