--Sword Art Champion Magus Dan
function c20912315.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd0a2),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c20912315.damcon)
	e1:SetOperation(c20912315.damop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912315,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c20912315.condition)
	e2:SetTarget(c20912315.target)
	e2:SetOperation(c20912315.operation)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(20912315,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c20912315.descon)
	e3:SetTarget(c20912315.destg)
	e3:SetOperation(c20912315.desop)
	c:RegisterEffect(e3)
	--LP gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20912315,3))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,20912315)
	e4:SetCondition(c20912315.reccon)
	e4:SetTarget(c20912315.rectg)
	e4:SetOperation(c20912315.recop)
	c:RegisterEffect(e4)
end
function c20912315.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c20912315.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c20912315.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c20912315.filter(c,e,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c20912315.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c20912315.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c20912315.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c20912315.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20912315,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if ft>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20912315,1)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c20912315.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<g:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end
function c20912315.crifilter(c,tp)
	return c:IsControler(tp)  and c:IsSetCard(0xd0a2) 
		and c:GetPreviousControler()==tp
end
function c20912315.descon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c20912315.crifilter,1,nil,tp)
end
function c20912315.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local tc=eg:GetFirst()
if chkc then return chkc==tc end
if chk==0 then return tc and tc:GetReasonCard() and tc:GetReasonCard():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc:GetReasonCard())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c20912315.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c20912315.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c20912315.recfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c20912315.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20912315.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912315.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c20912315.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c20912315.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
