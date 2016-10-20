--Wanda the Mystical Queen Angel
function c89990031.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--summon with 2 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(89990031,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c89990031.ttcon)
	e3:SetOperation(c89990031.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE+1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(89990031,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c89990031.con)
	e4:SetTarget(c89990031.tg)
	e4:SetOperation(c89990031.op)
	c:RegisterEffect(e4)
end
function c89990031.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=2
end
function c89990031.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g, REASON_SUMMON+REASON_MATERIAL)
end
function c89990031.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE+1
end
function c89990031.thfilter(c)
	return c:IsSetCard(0x22b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c89990031.filter1(c)
	return c:IsDestructable() and Duel.IsExistingTarget(c89990031.filter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c89990031.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c89990031.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local a=Duel.IsExistingMatchingCard(c89990031.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil)
	local b=Duel.IsExistingTarget(c89990031.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local op=2
	if a and b then
		op=Duel.SelectOption(tp,aux.Stringid(89990031,2),aux.Stringid(89990031,3))
	elseif a then
		Duel.SelectOption(tp,aux.Stringid(89990031,2))
		op=0
	elseif b then
		Duel.SelectOption(tp,aux.Stringid(89990031,3))
		op=1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==1 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,c89990031.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,c89990031.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	end
	Duel.SetTargetParam(op)
end
function c89990031.op(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if op==0 then
		local g=Duel.GetMatchingGroup(c89990031.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,2,2,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif op==1 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local dg=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
