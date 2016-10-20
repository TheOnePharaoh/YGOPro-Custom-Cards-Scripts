--Tornado Drake
function c103950023.initial_effect(c)

	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Destroy Spell/Traps
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950023,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c103950023.destg)
	e1:SetOperation(c103950023.desop)
	c:RegisterEffect(e1)
	
	--Change battle position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950023,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c103950023.poscon)
	e2:SetTarget(c103950023.postg)
	e2:SetOperation(c103950023.posop)
	c:RegisterEffect(e2)
end

--Destroy Spell/Traps target
function c103950023.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end

--Destroy Spell/Traps operation
function c103950023.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

--Change battle position condition
function c103950023.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsContains(e:GetHandler()) and e:GetHandler():IsFaceup()
end

--Change battle position target
function c103950023.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

--Change battle position operation
function c103950023.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end