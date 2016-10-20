--Arisugawa Otome
function c59821027.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821027.splimit)
	e2:SetCondition(c59821027.splimcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821027.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--sort deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821027,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCountLimit(1)
	e4:SetCondition(c59821027.cond)
	e4:SetTarget(c59821027.tgd)
	e4:SetOperation(c59821027.opd)
	c:RegisterEffect(e4)
end
function c59821027.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821027.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821027.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821027.cond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821027.tgd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c59821027.opd(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	local g=Duel.GetDecktopGroup(tp,dc)
	local ct=g:GetCount()
	Duel.ConfirmCards(tp,g)
	local op=Duel.SelectOption(tp,aux.Stringid(59821027,1),aux.Stringid(59821027,2))
	Duel.SortDecktop(tp,tp,ct)
	if op==0 then return end
	for i=1,ct do
		local tg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(tg:GetFirst(),1)
	end
end
