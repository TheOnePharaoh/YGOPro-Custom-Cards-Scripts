--Vocaloid Flower
function c41045210.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41045210,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c41045210.dracon)
	e1:SetTarget(c41045210.dratg)
	e1:SetOperation(c41045210.draop)
	c:RegisterEffect(e1)
	--synchro custom
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,41045210)
	e2:SetCondition(c41045210.syncon)
	e2:SetTarget(c41045210.syntg)
	e2:SetOperation(c41045210.synop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCondition(c41045210.syncon)
	c:RegisterEffect(e3)
end
function c41045210.dracon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c41045210.drafilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsPublic()
end
function c41045210.dratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c41045210.drafilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c41045210.draop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c41045210.drafilter,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct+1,REASON_EFFECT)
	end
end
function c41045210.syncon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c41045210.filter(c,e,tp,lv)
	return c:IsFaceup() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(c41045210.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetOriginalLevel())
end
function c41045210.scfilter(c,e,tp,lv)
	return c:IsSetCard(0x0dac402) and c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c41045210.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local lv=e:GetHandler():GetOriginalLevel()
	if chk==0 then return Duel.IsExistingTarget(c41045210.filter,tp,0,LOCATION_MZONE,1,nil,e,tp,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c41045210.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,lv)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c41045210.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 and c:GetLevel()>0 and c:IsLocation(LOCATION_GRAVE)
		and tc:GetLevel()>0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=c:GetLevel()+tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c41045210.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		local tc=sg:GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
