--El Shaddoll Laestrygonians
function c98441213.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c98441213.fuscon)
	e1:SetOperation(c98441213.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c98441213.splimit)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--tograve&draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98441213,0))
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c98441213.tgtg1)
	e4:SetOperation(c98441213.tgop1)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98441213,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	e5:SetTarget(c98441213.thtg)
	e5:SetOperation(c98441213.thop)
	c:RegisterEffect(e5)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98441213,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(c98441213.thtg2)
	e6:SetOperation(c98441213.thop2)
	c:RegisterEffect(e6)
end
function c98441213.ffilter1(c)
	return c:IsSetCard(0x9d)
end
function c98441213.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsHasEffect(4904633)
end
function c98441213.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c98441213.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98441213.exfilter,tp,0,LOCATION_MZONE,nil,g)
		exg:Merge(sg)
	end
	if gc then return (c98441213.ffilter1(gc) and (g:IsExists(c98441213.ffilter2,1,gc) or exg:IsExists(c98441213.ffilter2,1,gc)))
		or (c98441213.ffilter2(gc) and (g:IsExists(c98441213.ffilter1,2,gc) or exg:IsExists(c98441213.ffilter1,2,gc))) end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	local g4=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if c98441213.ffilter1(tc) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g3:AddCard(tc) end
		end
		if c98441213.ffilter2(tc) then
			g2:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g4:AddCard(tc) end
		end
		tc=g:GetNext()
	end
	local exg1=exg:Filter(c98441213.ffilter1,nil)
	local exg2=exg:Filter(c98441213.ffilter2,nil)
	if chkf~=PLAYER_NONE then
		return (g3:IsExists(aux.FConditionFilterF2,1,nil,g2)
			or g3:IsExists(aux.FConditionFilterF2,1,nil,exg2)
			or g4:IsExists(aux.FConditionFilterF2,1,nil,g1)
			or g4:IsExists(aux.FConditionFilterF2,2,nil,exg1))
	else
		return (g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
			or g1:IsExists(aux.FConditionFilterF2,1,nil,exg2)
			or g2:IsExists(aux.FConditionFilterF2,2,nil,exg1))
	end
end
function c98441213.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98441213.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
	end
	if gc then
		local sg1=Group.CreateGroup()
		local sg2=Group.CreateGroup()
		if c98441213.ffilter1(gc) then
			sg1:Merge(eg:Filter(c98441213.ffilter2,gc))
			sg2:Merge(exg:Filter(c98441213.ffilter2,gc))
		end
		if c98441213.ffilter2(gc) then
			sg1:Merge(eg:Filter(c98441213.ffilter1,gc))
			sg2:Merge(exg:Filter(c98441213.ffilter1,gc))
		end
		local g1=nil
		if sg1:GetCount()==0 or (sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0))) then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g1=sg2:Select(tp,2,2,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g1=sg1:Select(tp,2,2,nil)
		end
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(aux.FConditionFilterF2c,nil,c98441213.ffilter1,c98441213.ffilter2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	if c98441213.ffilter1(tc1) then
		sg1:Merge(sg:Filter(c98441213.ffilter2,tc1))
		sg2:Merge(exg:Filter(c98441213.ffilter2,tc1))
	end
	if c98441213.ffilter2(tc1) then
		sg1:Merge(sg:Filter(c98441213.ffilter1,tc1))
		sg2:Merge(exg:Filter(c98441213.ffilter1,tc1))
	end
	local g2=nil
	if sg1:GetCount()==0 or (sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0))) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2=sg2:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2=sg1:Select(tp,2,2,nil)
	end
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c98441213.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98441213.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c98441213.crifilter(c)
	return c:IsSetCard(0x9d) and c:IsLocation(LOCATION_GRAVE)
end
function c98441213.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c98441213.crifilter,nil)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c98441213.thfilter(c,e,tp)
	return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c98441213.spfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c98441213.spfilter2(c,e,tp)
	return c:IsSetCard(0x9d) and c:IsAbleToGrave()
end
function c98441213.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98441213.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c98441213.spfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c98441213.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c98441213.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98441213.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c98441213.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function c98441213.thadfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98441213.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98441213.thadfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98441213.thadfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98441213.thadfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98441213.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
