--Kurebayashi Juri
function c59821021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821021.splimit)
	e2:SetCondition(c59821021.splimcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821021.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--excavate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821021,0))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCountLimit(1,59821021)
	e6:SetCondition(c59821021.condition)
	e6:SetTarget(c59821021.target)
	e6:SetOperation(c59821021.operation)
	c:RegisterEffect(e6)
end
function c59821021.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821021.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821021.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821021.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c59821021.filter(c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821038) and c:IsAbleToHand()
end
function c59821021.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc)
	local g=dg:Filter(c59821021.filter,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end